//
//  Extensions.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import Foundation
import UIKit
import LinkPresentation
import RxSwift

extension UIImageView {
    func makeRounded(radius: CGFloat) {
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

extension CALayer {
   
    func applyCornerRadiusShadow(color: UIColor = .black,
                                 alpha: Float = 0.5,
                                 x: CGFloat = 0,
                                 y: CGFloat = 2,
                                 blur: CGFloat = 4) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
    
}

    
extension Notification.Name {
    static let keyboardWillShow     = UIResponder.keyboardWillShowNotification
    static let keyboardWillHide     = UIResponder.keyboardWillHideNotification
}

extension UITableViewCell {
    
    func getMeta(url: URL) -> Single<LPLinkMetadata> {
        return Single<LPLinkMetadata>.create { prom in
            LPMetadataProvider().startFetchingMetadata(for: url) { metadata, error in
                if let meta = metadata {
                    prom(.success(meta))
                } else if let error = error {
                    prom(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
}
