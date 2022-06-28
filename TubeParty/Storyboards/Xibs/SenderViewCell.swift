//
//  SenderViewCell.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import UIKit
import Kingfisher

class SenderViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        profileImage.makeRounded(radius: profileImage.frame.height/2)
        
        view.backgroundColor = .tpMainGreen
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        view.layer.applyCornerRadiusShadow(color: .tpMainGreen, alpha: 1, x: 0, y: 0, blur: 10.0)
    }
    
    func configure(name: String, text: String , url: String) {
        self.name.text = name
        self.message.text = text
        let imgURL = URL(string: url)
        profileImage.kf.setImage(with: imgURL)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
