//
//  SenderViewCell.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import UIKit

class SenderViewCell: UITableViewCell {

    @IBOutlet weak var senderIMG: UIImageView!
    @IBOutlet weak var senderProfileName: UILabel!
    @IBOutlet weak var senderMSG: UILabel!
    @IBOutlet weak var senderMSGView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        senderIMG.makeRounded(radius: senderIMG.frame.height/2)
        senderMSGView.makeViewRounded(radius: 6)
        senderMSGView.backgroundColor = .systemMainBlue
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepare() {
        // image
        senderIMG.layer.cornerRadius = senderIMG.layer.cornerRadius / 2
        
        // profile name
        senderProfileName.numberOfLines = 1
        
        // message background
        senderMSGView.layer.cornerRadius = 6
        
        // message
        senderMSG.numberOfLines = 0
    }

    func configure(_ text: String) {
        self.senderMSG.text = text
    }
}
