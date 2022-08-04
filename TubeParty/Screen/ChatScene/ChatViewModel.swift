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

enum SendMessageState {
    case success
    case failure
}

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

protocol ChatOutput {
    var isDisableSendButton: Driver<Bool> { get }
    var getChatMessage: Driver<[SectionModel]> { get }
    var getChatCount: Int { get }
    var getSendMessageState: Driver<SendMessageState> { get }
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
                .map({ [SectionModel(header: "ChatMessageHeader", items: $0)] })
                .asDriver(onErrorDriveWith: .never())
    }
    
    var getSendMessageState: Driver<SendMessageState> {
        return _getSendMessageState
            .asDriver(onErrorDriveWith: .never())
    }
    
    var getChatCount: Int {
        return _getChatMessage.value.count
    }
    
    // Properties
    private let _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    private let _getChatMessage: BehaviorRelay<[ChatItem]> = .init(value: [])
    private let _getSendMessageState: PublishRelay<SendMessageState> = .init()
    private let sendMessageUseCase: SendMessageUseCaseDomain
    private let getMessageUseCase: GetMesaageUseCaseDomain
    private let bag = DisposeBag()
    private var currentUserProfile: UserProfile?
    
    init(userChatName: String) {
        sendMessageUseCase = TubePartyUseCaseProvider().makeSendMessageUseCaseDomain()
        getMessageUseCase = TubePartyUseCaseProvider().makeGetMessageUseCaseDomain()
        
        self.binding()
    }
    
    private func binding() {
        
        viewDidload.bind { _ in
            // TODO:  if not used, should to remove it.
        }.disposed(by: bag)
        
        viewWillAppear.bind { [weak self] _ in
            guard let self = self else { return }
            if let userProfile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
                self.currentUserProfile = userProfile
            }
        }.disposed(by: bag)
        
        getMessageUseCase
            .getMessageList()
            .map { chatItem -> [ChatItem] in
                return chatItem.map({
                    return $0.senderID == self.currentUserProfile?.senderID ? .sender(model: $0) : .reciever(model: $0)
                }).sorted(by: { $0.timestamp < $1.timestamp })
            }
            .bind(to: _getChatMessage)
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
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        sendMessageSuccess
            .map({ _ in SendMessageState.success })
            .bind(to: _getSendMessageState)
            .disposed(by: bag)
        
        sendMessageFail
            .map({ _ in SendMessageState.failure })
            .bind(to: _getSendMessageState)
            .disposed(by: bag)
        
    }
}
