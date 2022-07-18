//
//  SettingViewController.swift
//  TubeParty
//
//  Created by iZE Appsynth on 18/7/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {

    @IBOutlet private var navTitle: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageChangeButton: UIButton!
    @IBOutlet private var profileNameField: UITextField!
    @IBOutlet private var saveButton: UIButton!
    
    var viewModel: SettingViewModelType!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        self.imageView.layer.cornerRadius = imageView.frame.height/2
        self.imageView.layer.borderWidth = 2
        
        self.saveButton.backgroundColor = UIColor.tpBlack
        self.saveButton.setTitleColor(UIColor.white, for: .normal)
        self.saveButton.setTitleColor(UIColor.tpGray, for: .highlighted)
        self.saveButton.layer.cornerRadius = 4
        self.saveButton.titleLabel?.font =  UIFont.normalRegular
    }
    
    func bindViewModel() {
        
        // output
        
        // inputs
        imageChangeButton
            .rx
            .tap
            .bind(to: viewModel.input.didTapChangeImage)
            .disposed(by: bag)
        
        saveButton
            .rx
            .tap
            .bind(to: viewModel.input.didTapSaveButton)
            .disposed(by: bag)
        
        viewModel
            .input
            .viewDidload
            .accept(())
        
    }

}
