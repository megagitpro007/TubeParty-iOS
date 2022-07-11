import FirebaseFirestore

final public class TubePartyUseCase: TubePartyUseCaseDomain {
    
    private let fireStore: Firestore
    private var ref: DocumentReference? = nil
    
    init(fireStore: Firestore) {
        self.fireStore = fireStore
    }
    
    public func sendMessage(newMessage: MessageModel) {
        self.ref = self.fireStore.collection("message_list")
            .addDocument(data: newMessage.toJSON()) { error in
                if let error = error  {
                    print("🔥 \(error.localizedDescription)")
                } else {
                    print("🔥 update success")
                }
            }
    }
    
    public func getMessageList() -> [MessageModel] {
        var messageList: [MessageModel] = []
        
        self.fireStore.collection("message_list").getDocuments { query, error in
            if let error = error {
                print("🔥 \(error.localizedDescription)")
            } else {
                for document in query!.documents {
                    let dict = document.data()
                    let decoder = JSONDecoder()
                    guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                          let newObject = try? decoder.decode(MessageModel.self, from: jsonData) else { return }
                    messageList.append(newObject)
                    print("🔥 \(newObject.message)")
                }
            }
        }
        
        return messageList
    }
    
}
