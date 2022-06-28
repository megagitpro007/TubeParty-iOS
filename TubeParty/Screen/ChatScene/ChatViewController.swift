//
//  ChatViewController.swift
//  TubeParty
//
//  Created by iZE Appsynth on 26/6/2565 BE.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

fileprivate let senderTableViewCell = "SenderViewCell"
fileprivate let receiverTableViewCell = "ReceiverViewCell"

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatBGView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    
    let textList = ["Hello", "ReceiverViewCell", "Bye"]
    
    var viewModel: ChatIOType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        registerCell()
    }
    
    func bindViewModel() {
        
    }
    
    func registerCell() {
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: senderTableViewCell, bundle: nil), forCellReuseIdentifier: senderTableViewCell)
    }
    
    func setupUI() {
        chatTableView.backgroundColor = .clear
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false

        // Set Title Style
        chatTitle.text = "Chat Screen"
        chatTitle.textColor = .systemMainBlue
        
        // Set Send message button color
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "paperplane.circle", withConfiguration: largeConfig)?.withTintColor(.systemMainBlue, renderingMode: .alwaysOriginal)
        sendButton.setImage(largeBoldDoc, for: .normal)
        sendButton.setTitle("", for: .normal)
        
        // Set Back button color
        let backConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let backBoldDoc = UIImage(systemName: "arrowshape.turn.up.backward.circle", withConfiguration: backConfig)?.withTintColor(.systemMainBlue, renderingMode: .alwaysOriginal)
        backButton.setImage(backBoldDoc, for: .normal)
        backButton.setTitle("", for: .normal)
        
        // Set typing field style
        typingField.layer.cornerRadius = 4
        typingField.layer.borderWidth = 2
        typingField.layer.borderColor = UIColor.systemGrayButton.cgColor
        typingField.tintColor = .systemGrayButton
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    // Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: senderTableViewCell, for: indexPath)
        
        if let cell = cell as? SenderViewCell {
            cell.name.text = textList[indexPath.row]
            cell.message.text = textList[indexPath.row]
            cell.setProfileImage(url: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004")
        }
        
        return cell
    }
    
}
