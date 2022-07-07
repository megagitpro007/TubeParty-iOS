import UIKit
import Kingfisher
import LinkPresentation
import RxSwift

class ReceiverViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var linkContainerView: UIView!
    
    private var linkPreviewView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        bag = DisposeBag()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.view.backgroundColor = .clear
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        self.profileImage.makeRounded(radius: self.profileImage.frame.height/2)
        self.name.textColor = .white
        self.message.textColor = .white
        self.timeStamp.textColor = .tpGray
        self.linkContainerView.layer.cornerRadius = 20
        
        self.linkContainerView.addSubview(self.linkPreviewView)
        self.linkPreviewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            linkPreviewView.centerXAnchor.constraint(equalTo: linkContainerView.centerXAnchor),
            linkPreviewView.centerYAnchor.constraint(equalTo: linkContainerView.centerYAnchor),
            linkPreviewView.widthAnchor.constraint(equalToConstant: linkContainerView.frame.width),
            linkPreviewView.heightAnchor.constraint(equalToConstant: linkContainerView.frame.height),
        ])
    }
    
    func configure(name: String, text: String, url: URL?, timeStamp: Date, linkPreview: URL? = nil) {
        self.name.text = name
        self.message.text = text
        self.timeStamp.text = timeStamp.chatTimeFormat()
        self.profileImage.kf.setImage(with: url)
        self.linkContainerView.isHidden = linkPreview == nil
    
        if let lplink = linkPreview {
            self.getMeta(url: lplink).subscribe { [weak self] metaData in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.linkPreviewView.metadata = metaData
                }
            } onFailure: { error in
                debugPrint("error : \(error.localizedDescription)")
            }.disposed(by: bag)

        }
    }

}
