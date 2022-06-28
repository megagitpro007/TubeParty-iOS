//
//  ReceiverViewCell.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import UIKit

class ReceiverViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var view: UIView!
    
    private var theShadowLayer: CAShapeLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.makeRounded(radius: profileImage.frame.height/2)
        
        view.backgroundColor = .systemMainBlue
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        view.layer.applyCornerRadiusShadow(color: .systemMainBlue, alpha: 1, x: 0, y: 0, blur: 10.0)
        
    }
    
    func setProfileImage(url: String) {
        let url = URL(string: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004")
        profileImage.kf.setImage(with: url)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
