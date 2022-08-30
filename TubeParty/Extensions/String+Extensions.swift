//
//  String+Exntensions.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 2/7/2565 BE.
//

import Foundation


extension String {
    
    func formatURL() -> URL? {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            return URL(string: String(self[range]))
        }
        return nil
    }
    
    func randomString() -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<15).map{ _ in letters.randomElement()! })
    }
    
}
