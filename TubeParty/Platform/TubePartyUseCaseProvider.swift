import FirebaseFirestore

final public class TubePartyUseCaseProvider: TubePartyUseCaseProviderDomain {
    
    private let fireStore: Firestore
    
    init(fireStore: Firestore) {
        self.fireStore = fireStore
    }
    
    public func makeTubePartyUseCaseDomain() -> TubePartyUseCaseDomain {
        return TubePartyUseCase(fireStore: fireStore)
    }
    
}
