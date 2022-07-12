import FirebaseFirestore
import RxSwift

final public class SendMessageUseCase: SendMessageUseCaseDomain {
    
    private let repo: TubePartyRepositories
    
    init(repo: TubePartyRepositories) {
        self.repo = repo
    }
    
    public func sendMessage(newMessage: MessageModel) {
        repo.sendMessage(newMessage: newMessage)
    }

}
