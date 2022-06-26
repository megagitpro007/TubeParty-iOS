//
//  ChatViewController.swift
//  TubeParty
//
//  Created by iZE Appsynth on 26/6/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ChatViewController: UIViewController {
    
    var viewModel: ChatIOType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    public func configViewModel(vm: ChatIOType) {
        self.viewModel = vm
    }
    

    private func bindViewModel() {
        
    }
    
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
