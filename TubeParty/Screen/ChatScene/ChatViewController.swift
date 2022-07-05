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
import LinkPresentation

fileprivate let senderTableViewCell = "SenderViewCell"
fileprivate let receiverTableViewCell = "ReceiverViewCell"

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatBGView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingField: UITextField!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var bottomViewContainer: UIView!
    
    let textList = ["message1", "message2", "message3", "message4","message5", "message6", "message7", "message8","message9", "ReceiverViewCell", "youtube https://www.youtube.com/watch?v=dRfafqSvoF8&ab_channel=UAStudios",
                    "Prettymuch https://www.prettymuch.com/ ",
                    "google https://www.facebook.com"]
    
    var isTextFieldSelected: Bool = false
    
    var viewModel: ChatIOType!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        registerCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: self.textList.count-1, section: 0)
        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func bindViewModel() {
        //input
        viewModel.input.viewDidload.accept(())
        
        typingField
            .rx
            .text.orEmpty.map({ text in
                return !text.isEmpty
            })
            .bind(to: viewModel.input.isValidText).disposed(by: bag)
        
        //output
        viewModel.output.isDisableSendButton.distinctUntilChanged().drive(onNext: { isDisable in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) { [weak self] in
                guard let self = self else { return }
                print("isDisable : \(isDisable)")
                self.sendButton.isUserInteractionEnabled = isDisable
                self.sendButton.isEnabled = isDisable
            }
        }).disposed(by: bag)
        
        NotificationCenter
            .default
            .rx
            .notification(.keyboardWillShow).bind { [weak self] notification in
                guard let self = self else { return }
                guard self.isTextFieldSelected else { return }
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let size = keyboardSize.height - self.view.safeAreaInsets.bottom
                    self.bottomViewContainer.transform = .init(translationX: 0, y: -size)
                    self.chatTableView.contentInset = .init(top: 0, left: 0, bottom: size + 10, right: 0)
                    
                    let indexPath = IndexPath(row: self.textList.count-1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    
                }
                print("🔥 : textFieldDidBeginEditing")
            }.disposed(by: bag)
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event.bind(onNext: { recognizer in
            // TODO:
        }).disposed(by: bag)
        
    }
    
    func registerCell() {
        chatTableView.dataSource = self
        chatTableView.register(UINib(nibName: senderTableViewCell, bundle: nil), forCellReuseIdentifier: senderTableViewCell)
        chatTableView.register(UINib(nibName: receiverTableViewCell, bundle: nil), forCellReuseIdentifier: receiverTableViewCell)
    }
    
    func setupUI() {
        typingField.delegate = self
        
        bottomViewContainer.backgroundColor = .tpGunmetal
        chatBGView.backgroundColor = .tpGunmetal
        
        chatTableView.backgroundColor = .clear
        chatTableView.separatorStyle = .none
        chatTableView.allowsSelection = false

        // Set Title Style
        chatTitle.text = "Chat Screen"
        chatTitle.textColor = .white
        
        // Set Send message button color
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "chevron.forward.circle.fill", withConfiguration: largeConfig)?.withTintColor(.tpMainBlue, renderingMode: .alwaysOriginal)
        sendButton.setImage(largeBoldDoc, for: .normal)
        sendButton.setTitle("", for: .normal)
        
        // Set typing field style
        textFieldContainer.layer.cornerRadius = textFieldContainer.bounds.height / 2
        typingField.layer.cornerRadius = 4
        typingField.layer.borderWidth = 0
        typingField.layer.borderColor = UIColor.clear.cgColor
        typingField.tintColor = .white
        typingField.textColor = .white
        typingField.attributedPlaceholder = NSAttributedString(
            string: "Type your message...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.tpGray]
        )
        
        typingField.backgroundColor = .clear
        textFieldContainer.backgroundColor = .tpArsenic
        
    }
    
    @objc func dismissKeyboard() {
        guard self.isTextFieldSelected else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.bottomViewContainer.transform = .identity
            self.chatTableView.transform = .identity
            
            self.chatTableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            let indexPath = IndexPath(row: self.textList.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
            self.view.endEditing(true)
            
        })
    }

}

extension ChatViewController: UITableViewDataSource {
    
    // Tableview Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        textList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: indexPath.row%2 == 0 ? senderTableViewCell : receiverTableViewCell, for: indexPath)
        if let cell = cell as? SenderViewCell {
            // Should to be `model`
            let text = textList[indexPath.row]
            cell.configure(
                name: "ice",
                text: text,
                url: "https://static.wikia.nocookie.net/love-exalted/images/1/1c/Izuku_Midoriya.png/revision/latest?cb=20211011173004",
                timeStamp: "11:11",
                linkPreview: text.formatURL()
            )
            
        } else if let cell = cell as? ReceiverViewCell {
            let text = textList[indexPath.row]
            cell.configure(
                name: "toney",
                text: text,
                url: "https://nntheblog.b-cdn.net/wp-content/uploads/2022/04/Arrangement-Katsuki-Bakugo.jpg",
                timeStamp: "11:11",
                linkPreview: text.formatURL()
            )
        }
        
        return cell
    }
    
}

extension ChatViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isTextFieldSelected = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isTextFieldSelected = false
    }
    
}
