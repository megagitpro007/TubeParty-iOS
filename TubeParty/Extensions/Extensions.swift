//
//  Extensions.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import Foundation
import UIKit

extension UIImageView {
    
    func makeRounded(radius: CGFloat) {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
}

extension UIView {
    
    func makeViewRounded(radius: CGFloat) {
        layer.cornerRadius = radius
    }
    
}
