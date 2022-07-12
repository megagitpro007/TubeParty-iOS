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

fileprivate let imageProfileURL = "https://assets.coingecko.com/coins/images/24155/large/zoro.png?1646565848"

protocol ChatIOType {
    var input: ChatInput { get }
    var output: ChatOutput { get }
}

protocol ChatInput {
    var viewDidload: PublishRelay<Void> { get }
    var isValidText: PublishRelay<Bool> { get }
    var messageInput: PublishRelay<String> { get }
    var didTabEnterButton: PublishRelay<Void> { get }
}

protocol ChatOutput {
    var isDisableSendButton: Driver<Bool> { get }
    var getChatMessage: Driver<[SectionModel]> { get }
    var getChatCount: Int { get }
}

enum ChatItem {
    case sender(model: MessageModel)
    case reciever(model: MessageModel)
}

extension ChatItem: IdentifiableType, Hashable {
    var identity: UUID {
        switch self {
        case .reciever(let model): return model.id
        case .sender(let model): return model.id
        }
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(identity)
    }
    
    static func == (lhs: ChatItem, rhs: ChatItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

class ChatViewModel: ChatIOType, ChatInput, ChatOutput {
    
    // IO Type
    var input: ChatInput { return self }
    var output: ChatOutput { return self }
    
    // Inputs
    var viewDidload: PublishRelay<Void> = .init()
    var isValidText: PublishRelay<Bool> = .init()
    var messageInput: PublishRelay<String> = .init()
    var didTabEnterButton: PublishRelay<Void> = .init()
    
    // Outputs
    var isDisableSendButton: Driver<Bool> {
        return _isDisableSendButton.asDriver(onErrorJustReturn: true)
    }
    
    var getChatMessage: Driver<[SectionModel]> {
        return _getChatMessage
                .map({ [SectionModel(header: "ChatMessageHeader", items: $0)] })
                .asDriver(onErrorDriveWith: .never())
    }
    
    var getChatCount: Int {
        return _getChatMessage.value.count
    }
    // Properties
    private let _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    private let _getChatMessage: BehaviorRelay<[ChatItem]> = .init(value: [])
    private var currentName: String = ""
    private let remoteConfig = RemoteConfig.remoteConfig()
    private let firebaseDB = Firestore.firestore()
    private var ref: DocumentReference? = nil
    private let bag = DisposeBag()
    
    init(userChatName: String) {
        
        let repository = TubePartyRepository(fireStore: firebaseDB)
        let sendUseCase = TubePartyUseCaseProvider(repo: repository).makeSendMessageUseCaseDomain()
        let getUseCase = TubePartyUseCaseProvider(repo: repository).makeGetMessageUseCaseDomain()
        
        viewDidload.map { [weak self] _ -> [ChatItem] in
            guard let self = self else { return [] }
            if let displayName: String = UserDefaultsManager.get(by:.displayName) {
                self.currentName = displayName
            }
            return []
        }
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        getUseCase.getMessageList().map { chatList -> [ChatItem] in
            var newInstance = self._getChatMessage.value
            for data in chatList {
                if data.profileName == self.currentName {
                    newInstance.append(.sender(model: data))
                } else {
                    newInstance.append(.reciever(model: data))
                }
            }
            return newInstance
        }
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        isValidText
            .map({$0})
            .bind(to: _isDisableSendButton)
            .disposed(by: bag)
        
        messageInput
            .map { [weak self] text -> [ChatItem] in
                guard let self = self, !text.isEmpty else {
                    return self?._getChatMessage.value ?? []
                }
                
                let newMessage = MessageModel(
                    // TODO - profile url need to save to user default, maybe create profile settings scene
                    profileName: self.currentName,
                    profileURL: URL(string: imageProfileURL),
                    message: text,
                    timeStamp: Date()
                )
                
                sendUseCase.sendMessage(newMessage: newMessage)
                
                var newInstance = self._getChatMessage.value
                newInstance.append(.sender(model: newMessage))
                return newInstance
            }
            .bind(to: _getChatMessage)
            .disposed(by: bag)
        
    }
}
