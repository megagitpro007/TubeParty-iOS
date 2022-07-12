import RxSwift

public protocol TubePartyUseCaseDomain {
    func sendMessage(newMessage: MessageModel)
    func getMessageList() -> Observable<[MessageModel]>
}
