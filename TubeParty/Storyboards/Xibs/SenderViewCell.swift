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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
