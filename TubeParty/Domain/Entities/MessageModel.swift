//
//  MessageModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 4/7/2565 BE.
//

import Foundation

public struct MessageModel: Codable {
    var id: UUID
    var profileName: String
    var profileURL: URL?
    var message: String
    var linkPreView: URL?
    var timeStamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case profileName = "profile_name"
        case profileURL = "profile_url"
        case message = "message"
        case timeStamp = "time_stamp"
    }
    
    init(profileName: String, profileURL: URL?, message: String, timeStamp: Date) {
        self.id = UUID()
        self.profileName = profileName
        self.message = message
        self.timeStamp = timeStamp
        self.profileURL = profileURL
        self.linkPreView = message.formatURL()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(profileName, forKey: .profileName)
        try container.encode(profileURL?.absoluteString ?? "", forKey: .profileURL)
        try container.encode(message, forKey: .message)
        try container.encode(Double(timeStamp.timeIntervalSince1970), forKey: .timeStamp)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let _id = try? container.decode(String.self, forKey: .id)
        if let uuid = UUID(uuidString: _id ?? "") {
            id = uuid
        } else {
            id = UUID()
        }
        
        profileName = try container.decode(String.self, forKey: .profileName)
        message = try container.decode(String.self, forKey: .message)
        
        let _profileURL = try? container.decode(String.self, forKey: .profileURL)
        if let url = URL(string: _profileURL ?? "") {
            profileURL = url
        } else {
            profileURL = nil
        }
        
        let _timeStamp = try container.decode(Double.self, forKey: .timeStamp)
        timeStamp = Date(timeIntervalSince1970: _timeStamp)
        
        linkPreView = message.formatURL()
        
    }
    
}

public struct MessageFromFireStore: Codable {
    var id: String
    var message: String
    var profileName: String
    var profileURL: String
    var timeStamp: String
}
