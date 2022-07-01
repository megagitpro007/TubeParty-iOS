import UIKit
import Kingfisher
import LinkPresentation

class ReceiverViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var linkPreviewView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        linkPreviewView.isHidden = true
    }
    
    func setupUI() {
        profileImage.makeRounded(radius: profileImage.frame.height/2)
        name.textColor = .white
        message.textColor = .white
        view.backgroundColor = .tpBlack
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.applyCornerRadiusShadow(color: .tpBlack, alpha: 1, x: 0, y: 0, blur: 10.0)
        timeStamp.textColor = .tpGray
        self.backgroundColor = .clear
        linkPreviewView.layer.cornerRadius = 20
    }
    
    func configure(name: String, text: String , url: String, timeStamp: String) {
        self.name.text = name
        self.message.text = text
        self.timeStamp.text = timeStamp
        let imgURL = URL(string: url)
        profileImage.kf.setImage(with: imgURL)
    }
    
    func setPreviewLink(urlPreview: String) {
        linkPreviewView.isHidden = false
        let provider = LPMetadataProvider()
        guard let url = URL(string: urlPreview) else { return }
        //Link Preview
        var linkView = LPLinkView()
        linkView = LPLinkView(url: url)
        linkView.removeFromSuperview()
        provider.startFetchingMetadata(for: url) { metadata, error in
          guard let metadata = metadata, error == nil else { return }
          DispatchQueue.main.async { [weak self] in
            guard let _ = self else { return }
            linkView.metadata = metadata
          }
        }
        
        linkView.frame = self.linkPreviewView.bounds
        self.linkPreviewView.addSubview(linkView)
        self.linkPreviewView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
