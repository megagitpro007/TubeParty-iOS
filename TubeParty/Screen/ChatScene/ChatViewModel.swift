//
//  ChatViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 26/6/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa

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
    var _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    
    var _getChatMessage: BehaviorRelay<[MessageModel]> = .init(value: [])
    
    var chatList = [MessageModel(profileName: "ize",
                                 profileURL: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                                 message: "message1",
                                 dateTime: "11:11 AM"),
                    
                    MessageModel(profileName: "Toney",
                                 profileURL: "https://nntheblog.b-cdn.net/wp-content/uploads/2022/04/Arrangement-Katsuki-Bakugo.jpg",
                                 message: "message2",
                                 dateTime: "11:11 AM"),
                    
                    MessageModel(profileName: "ize",
                                 profileURL: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                                 message: "message3",
                                 dateTime: "11:11 AM"),
                    
                    MessageModel(profileName: "Toney",
                                 profileURL: "https://nntheblog.b-cdn.net/wp-content/uploads/2022/04/Arrangement-Katsuki-Bakugo.jpg",
                                 message: "message4 Prettymuch https://www.prettymuch.com/ ",
                                 dateTime: "11:11 AM")]
    
    let bag = DisposeBag()
    
    init(userChatName: String) {
        
        viewDidload.map { [weak self] _ -> [MessageModel] in
            guard let self = self else { return [MessageModel(profileName: "",
                                                              profileURL: "",
                                                              message: "",
                                                              dateTime: "")] }
            var messageModel: [MessageModel] = []
            for data in self.chatList {
                messageModel.append(MessageModel(profileName: data.profileName,
                                                 profileURL: data.profileURL.absoluteString,
                                                 message: data.message,
                                                 dateTime: data.dateTime))
            }
            return messageModel
        }
        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
        isValidText
            .map({$0})
            .bind(to: _isDisableSendButton)
            .disposed(by: bag)
        
        didTabEnterButton
            .withLatestFrom(_getChatMessage)
            .withLatestFrom(messageInput) { (messageList, messageInput) -> [MessageModel] in
                
                print("🔥 \(Date().getStringFromDateFormat()) ")
                
                var name = ""
                if let displayName: String = UserDefaultsManager.get(by: .displayName) { name = displayName }
                
                let newMessage = MessageModel(profileName: name,
                                              profileURL: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                                              message: "\(messageInput)",
                                              dateTime: Date().getStringFromDateFormat())
                var newList = messageList
                newList.append(newMessage)
                
                return newList
    
            }
            .bind(to: _getChatMessage)
            .disposed(by: bag)
                                              
    }
}
