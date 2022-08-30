//
//  UserDefaults.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 1/7/2565 BE.
//

import Foundation


struct UserDefaultsManager {
    
    enum Keys {
        case userProfile
        var key: String {
            switch self {
                case .userProfile: return "USERDEFAULT_USER_PROFILE_KEY"
            }
        }
    }
    
    static func set<T: Codable>(_ value: T, by key: Keys) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        UserDefaults.standard.set(data, forKey: key.key)
    }
    
    static func get<T: Codable>(by key: Keys) -> T? {
        guard let data = UserDefaults.standard.object(forKey: key.key) as? Data,
              let object = try? JSONDecoder().decode(T.self, from: data) else { return nil }
        return object
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
