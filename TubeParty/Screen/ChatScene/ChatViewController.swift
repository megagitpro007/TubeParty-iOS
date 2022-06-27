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

fileprivate let senderTableViewCell: String = "SenderViewCell"

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatBGView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    
    let textList = ["Hello", "GoodHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHelloHello", "Bye"]
    
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
        chatTableView.register(UINib(nibName: senderTableViewCell, bundle: nil), forCellReuseIdentifier: senderTableViewCell)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
    }
    
    func setupUI() {
        
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

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: senderTableViewCell, for: indexPath)
        if let cell = cell as? SenderViewCell {
            cell.senderMSG.text = textList[indexPath.row]
        }
        return cell
    }
}
