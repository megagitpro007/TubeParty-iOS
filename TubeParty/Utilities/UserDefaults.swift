//
//  UserDefaults.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 1/7/2565 BE.
//

import Foundation


struct UserDefaultsManager {
    
    enum Keys {
        case displayName
        var key: String {
            switch self {
            case .displayName: return "USERDEFAULT_NAME_KEY"
            }
        }
    }
    
    static func set<T: Hashable>(_ value: T, by key: Keys) {
        UserDefaults.standard.set(value, forKey: key.key)
    }
    
    static func get<T: Hashable>(by key: Keys) -> T? {
        return UserDefaults.standard.object(forKey: key.key) as? T
    }
    
    static func remove(by key: Keys) {
        UserDefaults.standard.removeObject(forKey: key.key)
    }
    
    static func clear() {
        UserDefaults.resetStandardUserDefaults()
    }
}
