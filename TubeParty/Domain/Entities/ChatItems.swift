//
//  ChatItems.swift
//  TubeParty
//
//  Created by iZE Appsynth on 12/7/2565 BE.
//
import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import FirebaseRemoteConfig
import FirebaseFirestore

enum ChatItem {
    case sender(model: MessageModel)
    case reciever(model: MessageModel)
    
    var timestamp: Date {
        switch self {
        case .sender(let model): return model.timeStamp
        case .reciever(let model): return model.timeStamp
        }
    }
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
