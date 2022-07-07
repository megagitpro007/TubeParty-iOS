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
    var linkPreView: URL?
    var dateTime: String
    
    init(profileName: String, profileURL: String, message: String, dateTime: String) {
        self.profileName = profileName
        self.message = message
        self.dateTime = dateTime
        self.profileURL = URL(string: profileURL)!
        
        if let linkPreView = self.message.formatURL() {
            self.linkPreView = linkPreView
        }
        
    }
    
}
