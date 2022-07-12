public protocol TubePartyUseCaseProviderDomain {
    func makeSendMessageUseCaseDomain() -> SendMessageUseCaseDomain
    func makeGetMessageUseCaseDomain() -> GetMesaageUseCaseDomain
}
