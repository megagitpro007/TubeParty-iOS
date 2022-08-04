//
//  SettingViewController.swift
//  TubeParty
//
//  Created by iZE Appsynth on 18/7/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class SettingViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet private var navTitle: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageChangeButton: UIButton!
    @IBOutlet private var profileNameField: UITextField!
    @IBOutlet private var saveButton: UIButton!
    @IBOutlet private var backButton: UIButton!
    @IBOutlet private var nameFieldContainer: UIView!
    @IBOutlet private var uploadLabel: UILabel!
    @IBOutlet private var uploadView: UIView!
    
    var viewModel: SettingViewModelType!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        self.uploadView.isHidden = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.layer.cornerRadius = imageView.frame.height/2
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = UIColor.white.cgColor
        
        self.saveButton.backgroundColor = UIColor.tpMainGreen
        self.saveButton.setTitleColor(UIColor.black, for: .normal)
        self.saveButton.layer.cornerRadius = 4
        self.saveButton.titleLabel?.font =  UIFont.normalRegular
        self.navTitle.textColor = UIColor.white
        
        self.nameFieldContainer.layer.cornerRadius = 4
        self.nameFieldContainer.backgroundColor = .white
        self.profileNameField.tintColor = .tpGray
        self.profileNameField.backgroundColor = .white
        
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let backDoc = UIImage(systemName: "chevron.backward", withConfiguration: backConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.backButton.setImage(backDoc, for: .normal)
        self.backButton.setTitle("", for: .normal)
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .large)
        let doc = UIImage(systemName: "pencil.circle", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        self.imageChangeButton.setImage(doc, for: .normal)
        self.imageChangeButton.setTitle("", for: .normal)
        
        self.view.backgroundColor = .tpGunmetal
    }
    
    func bindViewModel() {
        
        // output
        viewModel
            .output
            .getCurrentProfile.drive(onNext: { [weak self] userProfile in
                guard let self = self else { return }
                self.profileNameField.text = userProfile.name
                if let url = URL(string: userProfile.profileURL) {
                    self.imageView.kf.setImage(with: url, placeholder: profilePlaceHolder)
                }
            }).disposed(by: bag)
        
        viewModel.output.showAlertSaved.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            let alert = UIAlertController(title: "", message: "Profile has Saved.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }).disposed(by: bag)
        
        viewModel.output.uploadPercentage.drive(onNext: { [weak self] percent in
            guard let self = self else { return }
            self.uploadView.isHidden = false
            self.uploadLabel.text = "Uploaded \(String(percent))%"
            if percent == 100 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.uploadView.isHidden = true
                }
            }
        }).disposed(by: bag)
        
        imageChangeButton
            .rx
            .tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.pickImage(type: .photoLibrary)
            }.disposed(by: bag)
        
        saveButton
            .rx
            .tap
            .map { self.profileNameField.text ?? "" }
            .bind(to: viewModel.input.didNameChange)
            .disposed(by: bag)
        
        viewModel
            .input
            .viewDidload
            .accept(())
        
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension SettingViewController: UIImagePickerControllerDelegate {
    
    func pickImage(type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // TODO: if not use should to remove it
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        self.imageView.image = image
        self.viewModel.input.uploadProfileIamge.accept(image)
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
