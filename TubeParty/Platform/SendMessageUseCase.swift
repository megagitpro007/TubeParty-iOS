import FirebaseFirestore
import RxSwift

final public class SendMessageUseCase: SendMessageUseCaseDomain {
    
    private let repository: TubePartyRepository
    
    init(repository: TubePartyRepository = TubePartyRepositoryImpl()) {
        self.repository = repository
    }
    
    public func sendMessage(newMessage: MessageModel) {
        repository.sendMessage(newMessage: newMessage)
    }

}
