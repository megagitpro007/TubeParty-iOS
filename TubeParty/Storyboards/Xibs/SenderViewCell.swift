import UIKit
import Kingfisher
import LinkPresentation

class SenderViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var linkContainerView: UIView!
    
    private var linkPreviewView: LPLinkView = LPLinkView(metadata: LPLinkMetadata())
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = .clear
        self.view.backgroundColor = .tpMainGreen
        self.view.layer.cornerRadius = 20
        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        self.profileImage.makeRounded(radius: profileImage.frame.height/2)
        self.name.textColor = .white
        self.message.textColor = .white
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
    
    func configure(name: String, text: String, url: String, timeStamp: String, linkPreview: URL? = nil) {
        self.name.text = name
        self.message.text = text
        self.timeStamp.text = timeStamp
        self.profileImage.kf.setImage(with: URL(string: url))
        self.linkContainerView.isHidden = linkPreview == nil
    
        if let lplink = linkPreview {
            self.getMetaData(url: lplink)
        }
    }

    private func getMetaData(url: URL) {
        LPMetadataProvider().startFetchingMetadata(for: url) { [weak self] metadata, error in
            guard let self = self, let metadata = metadata, error == nil else { return }
            DispatchQueue.main.async {
                self.linkPreviewView.metadata = metadata
            }
        }
    }
}
