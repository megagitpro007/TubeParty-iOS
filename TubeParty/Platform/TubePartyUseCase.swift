import FirebaseFirestore

final public class TubePartyUseCase: TubePartyUseCaseDomain {
    
    private let fireStore: Firestore
    private var ref: DocumentReference? = nil
    
    init(fireStore: Firestore) {
        self.fireStore = fireStore
    }
    
    public func sendMessage(newMessage: MessageModel) {
        self.ref = self.fireStore.collection("message_list")
            .addDocument(data: ["id": newMessage.id.uuidString,
                                "profileName": newMessage.profileName,
                                "profileURL": newMessage.profileURL?.absoluteString ?? "",
                                "message": newMessage.message,
                                "timeStamp": "\(newMessage.timeStamp)"
                               ]) { error in
                if let error = error  {
                    print("🔥 \(error.localizedDescription)")
                } else {
                    print("🔥 update success")
                }
            }
    }
    
    public func getMessageList() -> [MessageFromFireStore] {
        var messageList: [MessageFromFireStore] = []
        self.fireStore.collection("message_list").getDocuments { query, error in
            if let error = error {
                print("🔥 \(error.localizedDescription)")
            } else {
                for document in query!.documents {
                    let dict = document.data()
                    do {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .secondsSince1970
                        let obj = try decoder.decode(MessageFromFireStore.self, from: jsonData)
                        
                        print("🔥 \(obj.message)")
                        messageList.append(obj)
                    } catch {
                        print("🔥 obj fail")
                    }
                    
                }
            }
        }
        return messageList
    }
    
}
