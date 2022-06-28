//
//  ReceiverTableViewCell.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 28/6/2565 BE.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var messageBgView: UIView!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageBgView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepare()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func prepare() {
        self.selectionStyle = .none
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.image = UIImage(named: "winter")
        self.messageBgView.backgroundColor = .systemMainBlue
        self.messageBgView.layer.cornerRadius = 18
        self.messageBgView.layer.shadowColor = UIColor.systemMainBlue.withAlphaComponent(0.6).cgColor
        self.messageBgView.layer.shadowOpacity = 1
        self.messageBgView.layer.shadowOffset = .init(width: 3, height: 3)
        self.messageBgView.layer.shadowRadius = 10
        self.messageBgView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMinYCorner]
        self.messageLabel.font = .titleLight
        self.messageLabel.textColor = .white
        self.messageLabel.numberOfLines = 0
        self.timeLabel.font = .smallLight
        self.timeLabel.textColor = .gray
    }
    
    func configure(_ text: String, timeStamp: String) {
        self.messageLabel.text = text
        self.timeLabel.text = timeStamp
    }
}
