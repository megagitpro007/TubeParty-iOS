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
    var Output: ChatOutput { get }
}

protocol ChatInput {
    
}

protocol ChatOutput {
    
}

class ChatViewModel: ChatIOType, ChatInput, ChatOutput {
    
    var input: ChatInput { return self }
    var Output: ChatOutput { return self }
    
    init(userChatName: String) {
        print("userName: \(userChatName)")
    }
    
}
