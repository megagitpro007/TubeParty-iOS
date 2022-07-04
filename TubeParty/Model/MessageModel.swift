//
//  MessageModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 4/7/2565 BE.
//

import Foundation

class MessageModel {
    
    var profileName: String
    var profileURL: URL
    var message: String
    var linkPreView: String?
    var timeStamp: String
    
    init(profileName: String, profileURL: String, message: String, timeStamp: String, linkPreView: String? = nil ) {
        self.profileName = profileName
        self.message = message
        self.timeStamp = timeStamp
        self.linkPreView = linkPreView
        self.profileURL = URL(string: profileURL)!
    }
    
}
