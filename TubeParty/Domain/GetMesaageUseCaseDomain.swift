import RxSwift

public protocol GetMesaageUseCaseDomain {
    func getMessageList() -> Observable<[MessageModel]>
}
