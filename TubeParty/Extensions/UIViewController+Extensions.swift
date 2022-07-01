//
//  UIViewController+Extensions.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 1/7/2565 BE.
//

import Foundation
import UIKit

enum Storyboard {
    case main
    var instance: UIStoryboard {
        switch self {
        case .main: return UIStoryboard(name: "Main", bundle: nil)
        }
    }
}

enum Scene {
    case login
    case chat
    
    var name: String {
        switch self {
        case .login: return "MainLoginViewController"
        case .chat: return "ChatViewController"
        }
    }
}

extension UIViewController {
    func replaceRoot(vc: UIViewController) {
        UIApplication.shared.windows.first?.rootViewController = vc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
