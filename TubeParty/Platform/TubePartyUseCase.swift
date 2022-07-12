import FirebaseFirestore
import RxSwift

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
    
    public func getMessageList() -> Observable<[MessageModel]> {
        return Observable.create { [weak self] observer -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.fireStore.collection("message_list").addSnapshotListener { query, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    var messageList: [MessageModel] = []
                    for document in query!.documents {
                        let dict = document.data()
                        let decoder = JSONDecoder()
                        guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted),
                              let newObject = try? decoder.decode(MessageModel.self, from: jsonData) else { return }
                        messageList.append(newObject)
                    }
                    observer.onNext(messageList)
                }
            }
            return Disposables.create()
        }
    }
    
}
