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
    var isValidText: PublishRelay<Bool> { get }
}

protocol ChatOutput {
    var isDisableSendButton: Driver<Bool> { get }
}

class ChatViewModel: ChatIOType, ChatInput, ChatOutput {
    
    // IO Type
    var input: ChatInput { return self }
    var output: ChatOutput { return self }
    
    // Inputs
    var isValidText: PublishRelay<Bool> = .init()
    
    // Outputs
    var isDisableSendButton: Driver<Bool> {
        return _isDisableSendButton.asDriver(onErrorJustReturn: true)
    }
    
    // Properties
    var _isDisableSendButton: BehaviorRelay<Bool> = .init(value: true)
    let bag = DisposeBag()
    
    init(userChatName: String) {
        
        print("userName: \(userChatName)")
        
        isValidText
            .map({ $0 })
            .bind(to: _isDisableSendButton)
            .disposed(by: bag)
        
    }
    
}
