import UIKit
import RxSwift
import RxCocoa

class MainLoginViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    let bag = DisposeBag()
    let viewModel: MainLoginIOType = MainLoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        self.logoImage.image = UIImage(systemName: "message.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        mainView.backgroundColor = UIColor.systemMainGreen
        loginView.layer.cornerRadius = 6
        
        submitButton.backgroundColor = UIColor.systemBlackButton
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitleColor(UIColor.systemGrayButton, for: .highlighted)
        submitButton.layer.cornerRadius = 4
        submitButton.titleLabel?.font =  UIFont.systemMedium

        nameTextfield.layer.cornerRadius = 4
        nameTextfield.layer.borderWidth = 2
        nameTextfield.layer.borderColor = UIColor.systemGrayButton.cgColor
        nameTextfield.tintColor = .systemGrayButton
    }
    
    func bindViewModel() {
        
        nameTextfield
            .rx.text.orEmpty
            .bind(to: viewModel.input.textFieldData)
            .disposed(by: bag)
        
        submitButton
            .rx.tap
            .bind(to: viewModel.input.didTapEnterButton)
            .disposed(by: bag)
        
    }

}

