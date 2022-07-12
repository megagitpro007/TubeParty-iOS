import FirebaseFirestore
import RxSwift

final public class GetMessageUseCase: GetMesaageUseCaseDomain {
    
    private let repo: TubePartyRepositories
    
    init(repo: TubePartyRepositories) {
        self.repo = repo
    }
    
    public func getMessageList() -> Observable<[MessageModel]> {
        repo.getMessageList()
    }
}
