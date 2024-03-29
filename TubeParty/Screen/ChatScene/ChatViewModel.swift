//
//  ChatViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 26/6/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseRemoteConfig
import FirebaseFirestore
import FirebaseStorage
import UIKit

fileprivate let imageProfileURL = "https://assets.coingecko.com/coins/images/24155/large/zoro.png?1646565848"

protocol ChatIOType {
    var input: ChatInput { get }
    var output: ChatOutput { get }
}

protocol ChatInput {
    var viewDidload: PublishRelay<Void> { get }
    var viewWillAppear: PublishRelay<Void> { get }
    var isValidText: PublishRelay<Bool> { get }
    var messageInput: PublishRelay<String> { get }
    var didTabEnterButton: PublishRelay<Void> { get }
    var didTapSettingButton: PublishRelay<Void> { get }
}

protocol ChatOutput: BaseOutput {
    var isDisableSendButton: Driver<Bool> { get }
    var getChatMessage: Driver<[SectionModel]> { get }
    var getChatCount: Int { get }
    var error: Driver<Error> { get }
    var openYoutubePlayer: Driver<URL> { get }
}

class ChatViewModel: ChatIOType, ChatInput, ChatOutput {
    
    // IO Type
    var input: ChatInput { return self }
    var output: ChatOutput { return self }
    
    // Inputs
    var viewDidload: PublishRelay<Void> = .init()
    var viewWillAppear: PublishRelay<Void> = .init()
    var isValidText: PublishRelay<Bool> = .init()
    var messageInput: PublishRelay<String> = .init()
    var didTabEnterButton: PublishRelay<Void> = .init()
    var didTapSettingButton: PublishRelay<Void> = .init()
    
    // Outputs
    var isDisableSendButton: Driver<Bool> {
        return _isDisableSendButton.asDriver(onErrorJustReturn: true)
    }
    
    var getChatMessage: Driver<[SectionModel]> {
        return _getChatMessage
            .map { chatItems -> [SectionModel] in
                return chatItems.reduce([]) { pre, next in
                    var _pre = pre
                    if let index = _pre.firstIndex(where: { $0.header == next.timestamp.dateForHeader() }) {
                        _pre[index].items.append(next)
                        return _pre
                    }
                    _pre.append(SectionModel(header: next.timestamp.dateForHeader(), items: [next]))
                    return _pre
                }
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    var openYoutubePlayer: Driver<URL> {
        return _youtubeURL
            .asDriver(onErrorDriveWith: .never())
    }
    
    var error: Driver<Error> {
        return _error
            .asDriver(onErrorDriveWith: .never())
    }
    
    var getChatCount: Int {
        return _getChatMessage.value.count
    }
    
    // Properties
    private let _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    private let _getChatMessage: BehaviorRelay<[ChatItem]> = .init(value: [])
    private let _error: PublishRelay<Error> = .init()
    private let sendMessageUseCase: SendMessageUseCaseDomain
    private let getMessageUseCase: GetMesaageUseCaseDomain
    private let bag = DisposeBag()
    private var currentUserProfile: UserProfile?
    private var _youtubeURL: PublishRelay<URL> = .init()
    
    init(userChatName: String) {
        sendMessageUseCase = TubePartyUseCaseProvider().makeSendMessageUseCaseDomain()
        getMessageUseCase = TubePartyUseCaseProvider().makeGetMessageUseCaseDomain()
        
        self.binding()
    }
    
    private func binding() {
        
        viewWillAppear.bind { [weak self] _ in
            guard let self = self else { return }
            if let userProfile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
                self.currentUserProfile = userProfile
            }
        }.disposed(by: bag)
        
        let getMessageList = viewDidload.flatMapLatest { [weak self] _ -> Observable<Event<[MessageModel]>> in
            guard let self = self else { return .never()}
            return self.getMessageUseCase.getMessageList().materialize()
        }.share()
        
        let getMessageListSuccess = getMessageList.compactMap({ $0.element })
        let getMessageListFail = getMessageList.compactMap({ $0.error })
        
        getMessageListSuccess.map { chatItem -> [ChatItem] in
            return chatItem.map({
                return $0.senderID == self.currentUserProfile?.senderID ? .sender(model: $0) : .reciever(model: $0)
            }).sorted(by: { $0.timestamp < $1.timestamp })
        }
        .do(onNext: { [weak self] chatItems in
            guard let self = self else { return }
            switch chatItems.last {
                case .reciever(let message):
                    if message.message.contains("youtube") {
                        let url = message.linkPreView
                        self._youtubeURL.accept(url!)
                    }
                case .sender(let message):
                    if message.message.contains("youtube") {
                        let url = message.linkPreView
                        self._youtubeURL.accept(url!)
                    }
                default:
                    break
            }
        })
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        getMessageListFail
            .bind(to: _error)
            .disposed(by: bag)
        
        isValidText
            .map({$0})
            .bind(to: _isDisableSendButton)
            .disposed(by: bag)
        
        let sendMessage = messageInput.flatMapLatest { [weak self] text -> Observable<Event<Void>> in
            guard let self = self, text != "" else { return .never() }
            let newMessage = MessageModel( profileName: self.currentUserProfile?.name ?? "",
                                           profileURL: URL(string: self.currentUserProfile?.profileURL ?? "" ),
                                           message: text,
                                           timeStamp: Date(),
                                           senderID: self.currentUserProfile?.senderID ?? "")
            return self.sendMessageUseCase.sendMessage(newMessage: newMessage).materialize()
        }.share()
        
        let sendMessageSuccess = sendMessage.compactMap({ $0.event.element })
        let sendMessageFail = sendMessage.compactMap({ $0.event.error })
        
        sendMessageSuccess.withLatestFrom(getMessageUseCase .getMessageList()).map { chatItem -> [ChatItem] in
            return chatItem.map({
                return $0.senderID == self.currentUserProfile?.senderID ? .sender(model: $0) : .reciever(model: $0)
            }).sorted(by: { $0.timestamp < $1.timestamp })
        }
        .do(onNext: { [weak self] chatItems in
            guard let self = self else { return }
            switch chatItems.last {
                case .reciever(let message):
                    if message.message.contains("youtube") {
                        let url = message.linkPreView
                        self._youtubeURL.accept(url!)
                    }
                case .sender(let message):
                    if message.message.contains("youtube") {
                        let url = message.linkPreView
                        self._youtubeURL.accept(url!)
                    }
                default:
                    break
            }
        })
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        sendMessageFail
            .bind(to: _error)
            .disposed(by: bag)
        
    }
    
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
