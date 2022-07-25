//
//  UserProfile.swift
//  TubeParty
//
//  Created by iZE Appsynth on 23/7/2565 BE.
//

import Foundation

public struct UserProfile: Codable {
    var name: String
    var profileURL: String
    var senderID: String
    
    init(name: String, profileURL: String, senderID: String) {
        self.name = name
        self.profileURL = profileURL
        self.senderID = senderID
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileURL
        case senderID
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(profileURL, forKey: .profileURL)
        try container.encode(senderID, forKey: .senderID)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        profileURL = try container.decode(String.self, forKey: .profileURL)
        senderID = try container.decode(String.self, forKey: .senderID)
    }
    
    public mutating func replaceName(_ name: String) {
        self.name = name
    }
    
    public mutating func replaceURL(_ url: URL) {
        self.profileURL = url.absoluteString
    }
    
    
    static func empty() -> UserProfile {
        return self.init(name: "", profileURL: "", senderID: "")
    }
}
