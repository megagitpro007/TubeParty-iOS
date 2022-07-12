import RxSwift

public protocol SendMessageUseCaseDomain {
    func sendMessage(newMessage: MessageModel)
}

