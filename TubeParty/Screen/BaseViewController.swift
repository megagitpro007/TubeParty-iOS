//
//  BaseViewController.swift
//  TubeParty
//
//  Created by iZE Appsynth on 4/8/2565 BE.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
