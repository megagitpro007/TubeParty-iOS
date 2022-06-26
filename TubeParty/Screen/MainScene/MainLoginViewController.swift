import UIKit
import RxSwift
import RxCocoa

class MainLoginViewController: UIViewController, MainViewControllerDelegate {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    private var viewModel: MainLoginIOType = MainLoginViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.delegate = self
    }
    
    private func setupUI() {
        warningLabel.isHidden = true
        submitButton.isEnabled = false
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
            .rx
            .text.orEmpty.map({ text in
                return !text.isEmpty
            })
            .bind(to: viewModel.input.isValidName).disposed(by: bag)
        
        submitButton
            .rx.tap
            .bind(to: viewModel.input.didTapEnterButton)
            .disposed(by: bag)

        viewModel.output.showErrorState.distinctUntilChanged().drive(onNext: { isErrorShow in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) { [weak self] in
                guard let self = self else { return }
                self.warningLabel.isHidden = isErrorShow
                self.submitButton.isEnabled = isErrorShow
            }
        }).disposed(by: bag)
    }
    
    func didTapEnterButton() {
        let vc = ChatViewController()
        let vm = ChatViewModel(userChatName: nameTextfield.text ?? "")
        vc.viewModel = vm
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
    
}

