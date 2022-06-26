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
        self.setupUI()
        self.setGradient()
        self.bindViewModel()
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
    
    func setGradient() {
        let gradient: CAGradientLayer = CAGradientLayer(
            start: .topLeft,
            end: .bottomRight,
            colors: [UIColor.systemMainGreen.cgColor, UIColor.systemMainBlue.cgColor]
        )
        gradient.frame = mainView.layer.frame
        mainView.layer.insertSublayer(gradient, at: 0)
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
            }
        }).disposed(by: bag)

        
    }
    
}
