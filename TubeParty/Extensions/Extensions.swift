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
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}
