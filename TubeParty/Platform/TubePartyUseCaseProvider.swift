import FirebaseFirestore

final public class TubePartyUseCaseProvider: TubePartyUseCaseProviderDomain {
    
    private let repo: TubePartyRepositories
    
    init(repo: TubePartyRepositories) {
        self.repo = repo
    }
    
    public func makeSendMessageUseCaseDomain() -> SendMessageUseCaseDomain {
        return SendMessageUseCase(repo: repo)
    }
    
    public func makeGetMessageUseCaseDomain() -> GetMesaageUseCaseDomain {
        return GetMessageUseCase(repo: repo)
    }
    
}
