public protocol TubePartyUseCaseProviderDomain {
    func makeSendMessageUseCaseDomain() -> SendMessageUseCaseDomain
    func makeGetMessageUseCaseDomain() -> GetMesaageUseCaseDomain
    func makeUploadImageUseCaseDomain() -> UploadImageUseCaseDomain
    func makeUpdateProfileUseCaseDomain() -> UpdateProfileUseCaseDomain
}
