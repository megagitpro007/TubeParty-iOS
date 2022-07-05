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
}

protocol ChatOutput {
    var isDisableSendButton: Driver<Bool> { get }
    var getChatMessage: Driver<SectionModel> { get }
}

class ChatViewModel: ChatIOType, ChatInput, ChatOutput {
    
    // IO Type
    var input: ChatInput { return self }
    var output: ChatOutput { return self }
    
    // Inputs
    var viewDidload: PublishRelay<Void> = .init()
    var isValidText: PublishRelay<Bool> = .init()
    
    // Outputs
    var isDisableSendButton: Driver<Bool> {
        return _isDisableSendButton.asDriver(onErrorJustReturn: true)
    }
    
    var getChatMessage: Driver<SectionModel> {
        _getChatMessage.asDriver(onErrorDriveWith: .never())
    }
    
    // Properties
    var _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    var _getChatMessage: BehaviorRelay<SectionModel> = .init(value: SectionModel(header: "", items: []))
    
    let chatList = [MessageModel(profileName: "ize",
                                 profileURL: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                                 message: "message1",
                                 timeStamp: "11:11"),
                    
                    MessageModel(profileName: "Toney",
                                 profileURL: "https://nntheblog.b-cdn.net/wp-content/uploads/2022/04/Arrangement-Katsuki-Bakugo.jpg",
                                 message: "message2",
                                 timeStamp: "11:11"),
                    
                    MessageModel(profileName: "ize",
                                 profileURL: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                                 message: "message3",
                                 timeStamp: "11:11"),
                    
                    MessageModel(profileName: "Toney",
                                 profileURL: "https://nntheblog.b-cdn.net/wp-content/uploads/2022/04/Arrangement-Katsuki-Bakugo.jpg",
                                 message: "message4 Prettymuch https://www.prettymuch.com/ ",
                                 timeStamp: "11:11")]
    
    let bag = DisposeBag()
    
    init(userChatName: String) {
        
        isValidText
            .map({$0})
            .bind(to: _isDisableSendButton)
            .disposed(by: bag)
        
        viewDidload.map { [weak self] _ -> SectionModel in

            guard let self = self else { return SectionModel(header: "", items: []) }

            var messageModel: [MessageModel] = []

            for data in self.chatList {
                messageModel.append(MessageModel(profileName: data.profileName,
                                                 profileURL: data.profileURL.absoluteString,
                                                 message: data.message,
                                                 timeStamp: data.timeStamp))
            }
            return SectionModel(header: "ChatMessageHeader", items: messageModel)
        }

        .bind(to: _getChatMessage)
        .disposed(by: bag)
        
    }
}
