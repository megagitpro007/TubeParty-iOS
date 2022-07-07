//
//  Date+Extensions.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 7/7/2565 BE.
//

import Foundation

extension Date {
    
    private static let hh_mm_a: String = "hh:mm a"
    
    func chatTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = Date.hh_mm_a
        return formatter.string(from: self)
    }
}
