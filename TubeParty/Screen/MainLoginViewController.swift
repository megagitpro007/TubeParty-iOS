import UIKit
import RxSwift
import RxCocoa

class MainLoginViewController: UIViewController {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    private let viewModel: MainLoginIOType = MainLoginViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        warningLabel.isHidden = true
        self.logoImage.image = UIImage(systemName: "message.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        mainView.backgroundColor = UIColor.systemMainGreen
        loginView.layer.cornerRadius = 6
        
        submitButton.backgroundColor = UIColor.systemBlackButton
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.setTitleColor(UIColor.systemGrayButton, for: .highlighted)
        submitButton.layer.cornerRadius = 4
        submitButton.titleLabel?.font =  UIFont.normalRegular

        nameTextfield.layer.cornerRadius = 4
        nameTextfield.layer.borderWidth = 2
        nameTextfield.layer.borderColor = UIColor.systemGrayButton.cgColor
        nameTextfield.tintColor = .systemGrayButton
    }
    
    private func bindViewModel() {
        
        nameTextfield
            .rx.text.orEmpty
            .bind(to: viewModel.input.textFieldData)
            .disposed(by: bag)
        
        submitButton
            .rx.tap
            .bind(to: viewModel.input.didTapEnterButton)
            .disposed(by: bag)
        
    }

    @IBAction func testasdasd(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            self.warningLabel.isHidden = !self.warningLabel.isHidden
        } completion: { _ in
            
        }

    }
}

