//
//  MessageModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 4/7/2565 BE.
//

import Foundation

struct MessageModel: Codable {
    var id: UUID
    var profileName: String
    var profileURL: URL?
    var message: String
    var linkPreView: URL?
    var timeStamp: Date
    
    init(profileName: String, profileURL: URL?, message: String, timeStamp: Date) {
        self.id = UUID()
        self.profileName = profileName
        self.message = message
        self.timeStamp = timeStamp
        self.profileURL = profileURL
        self.linkPreView = message.formatURL()
    }
    
}

struct MessageFromFireStore: Codable {
    var id: String
    var message: String
    var profileName: String
    var profileURL: String
    var timeStamp: String
}
