//
//  SenderViewCell.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import UIKit
import Kingfisher
import LinkPresentation

class SenderViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        testMetaData(urlPreview: "https://apkpure.com/th/mha-the-strongest-hero/com.mhatsh.eu")
    }
    
    func setupUI() {
        profileImage.makeRounded(radius: profileImage.frame.height/2)
        name.textColor = .white
        message.textColor = .white
        view.backgroundColor = .tpMainGreen
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.applyCornerRadiusShadow(color: .tpMainGreen, alpha: 1, x: 0, y: 0, blur: 10.0)
        self.backgroundColor = .clear
    }
    
    func configure(name: String, text: String, url: String, timeStamp: String) {
        self.name.text = name
        self.message.text = text
        self.timeStamp.text = timeStamp
        let imgURL = URL(string: url)
        profileImage.kf.setImage(with: imgURL)
    }

    func testMetaData(urlPreview: String) {
        var provider = LPMetadataProvider()
        guard let url = URL(string: urlPreview) else { return }
        //Link Preview
        var linkView = LPLinkView()
        linkView = LPLinkView(url: url)
        linkView.removeFromSuperview()
        
        provider.startFetchingMetadata(for: url) { metadata, error in
          guard let metadata = metadata, error == nil else { return }
          DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            linkView.metadata = metadata
          }
        }
        
//        linkView.frame = self.previewView.bounds
//        self.previewView.addSubview(linkView)
//        self.previewView.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
