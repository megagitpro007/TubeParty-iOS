import FirebaseFirestore
import RxSwift

final public class GetMessageUseCase: GetMesaageUseCaseDomain {
    
    private let repository: TubePartyRepository
    
    init(repository: TubePartyRepository = TubePartyRepositoryImpl()) {
        self.repository = repository
    }
    
    public func getMessageList() -> Observable<[MessageModel]> {
        repository.getMessageList()
    }
}
