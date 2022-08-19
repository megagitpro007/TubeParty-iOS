//
//  Date+Extensions.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 7/7/2565 BE.
//

import Foundation

extension Date {
    
    private static let hh_mm_a: String = "hh:mm a"
    private static let d_mmm_yyyy: String = "d MMM yyyy"
    
    private func dateFormater(format: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func chatTimeFormat() -> String {
        return dateFormater(format: Date.hh_mm_a)
    }
    
    func dateForHeader() -> String{
        return dateFormater(format: Date.d_mmm_yyyy)
    }
    
}
