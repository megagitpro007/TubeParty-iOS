import FirebaseFirestore

final public class TubePartyUseCaseProvider: TubePartyUseCaseProviderDomain {
    
    public init() {}
    
    public func makeSendMessageUseCaseDomain() -> SendMessageUseCaseDomain {
        return SendMessageUseCase()
    }
    
    public func makeGetMessageUseCaseDomain() -> GetMesaageUseCaseDomain {
        return GetMessageUseCase()
    }
    
}
