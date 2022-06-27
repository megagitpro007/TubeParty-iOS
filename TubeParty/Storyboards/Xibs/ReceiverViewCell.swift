//
//  ReceiverViewCell.swift
//  TubeParty
//
//  Created by iZE Appsynth on 27/6/2565 BE.
//

import UIKit

class ReceiverViewCell: UITableViewCell {

    @IBOutlet weak var receiverIMG: UIImageView!
    @IBOutlet weak var receiverName: UILabel!
    @IBOutlet weak var receiverMSG: UILabel!
    @IBOutlet weak var receiverMSGView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        receiverIMG.makeRounded(radius: receiverIMG.frame.height/2)
        receiverMSGView.makeViewRounded(radius: 6)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
