public protocol TubePartyUseCaseDomain {
    func sendMessage(newMessage: MessageModel)
    func getMessageList() -> [MessageModel]
}
