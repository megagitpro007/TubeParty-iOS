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
import FirebaseRemoteConfig
import YouTubePlayer

fileprivate let senderTableViewCell = "SenderViewCell"
fileprivate let receiverTableViewCell = "ReceiverViewCell"
fileprivate let sectionDate = "DateSectionView"

class ChatViewController: BaseViewController {
    
    @IBOutlet private var chatBGView: UIView!
    @IBOutlet private var sendButton: UIButton!
    @IBOutlet private var typingField: UITextField!
    @IBOutlet private var chatTitle: UILabel!
    @IBOutlet private var chatTableView: UITableView!
    @IBOutlet private var textFieldContainer: UIView!
    @IBOutlet private var bottomViewContainer: UIView!
    @IBOutlet private var settingButton: UIButton!
    
    @IBOutlet private var videoPlayer: YouTubePlayerView!
    
    var isTextFieldSelected: Bool = false
    
    var dataSource: RxTableViewSectionedReloadDataSource<SectionModel>!
    var viewModel: ChatIOType!
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupUI()
        self.registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.viewWillAppear.accept(())
    }
    
    func registerCell() {
        self.chatTableView.register(UINib(nibName: senderTableViewCell, bundle: nil), forCellReuseIdentifier: senderTableViewCell)
        self.chatTableView.register(UINib(nibName: receiverTableViewCell, bundle: nil), forCellReuseIdentifier: receiverTableViewCell)
        self.chatTableView.register(UINib(nibName: sectionDate, bundle: nil), forHeaderFooterViewReuseIdentifier: sectionDate)
    }
    
    func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        
        self.videoPlayer.isHidden = true
        
        typingField.delegate = self
        chatTableView.delegate = self
        videoPlayer.delegate = self
        
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
        
        // Set Setting button color
        let settingIconConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        let settingIconConfigDoc = UIImage(systemName: "gearshape.fill", withConfiguration: settingIconConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        settingButton.setImage(settingIconConfigDoc, for: .normal)
        settingButton.setTitle("", for: .normal)
        
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
    
    func bindViewModel() {
        
        // output
        viewModel.output.error.drive(onNext: { [weak self] error in
            guard let self = self else { return }
            self.showAlert(message: error.localizedDescription)
        }).disposed(by: bag)
        
        viewModel
            .output
            .isDisableSendButton
            .distinctUntilChanged()
            .drive(onNext: { isDisable in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut) { [weak self] in
                    guard let self = self else { return }
                    self.sendButton.isUserInteractionEnabled = isDisable
                    self.sendButton.isEnabled = isDisable
                }
            }).disposed(by: bag)
        
        NotificationCenter
            .default
            .rx
            .notification(.keyboardWillShow)
            .bind { [weak self] notification in
                guard let self = self else { return }
                guard self.isTextFieldSelected else { return }
                if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    let size = keyboardSize.height - self.view.safeAreaInsets.bottom
                    self.bottomViewContainer.transform = .init(translationX: 0, y: -size)
                    self.chatTableView.contentInset = .init(top: 0, left: 0, bottom: size + 10, right: 0)
                    self.scrollToBottom()
                }
            }.disposed(by: bag)
        
        viewModel.output.openYoutubePlayer.drive(onNext: { [weak self] url in
            guard let self = self else { return }
            self.videoPlayer.loadVideoURL(url)
        }).disposed(by: bag)
        
        // Do not implement configulation of view in binding function
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // Datasource
        dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { [weak self] (datasource, tableview, indexpath, item) -> UITableViewCell in
            guard let self = self else { return UITableViewCell() }
            switch item {
            case .sender(model: let model):
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: senderTableViewCell, for: indexpath)
                if let cell = cell as? SenderViewCell {
                    cell.configure(
                        name: model.profileName,
                        text: model.message,
                        url: model.profileURL,
                        timeStamp: model.timeStamp,
                        linkPreview: model.message.formatURL()
                    )
                }
                return cell
            case .reciever(model: let model):
                let cell = self.chatTableView.dequeueReusableCell(withIdentifier: receiverTableViewCell, for: indexpath)
                if let cell = cell as? ReceiverViewCell {
                    cell.configure(
                        name: model.profileName,
                        text: model.message,
                        url: model.profileURL,
                        timeStamp: model.timeStamp,
                        linkPreview: model.message.formatURL()
                    )
                }
                return cell
            }
        })
        
        viewModel
            .output
            .getChatMessage
            .do(afterNext: { [weak self] _ in
                guard let self = self else { return }
                self.scrollToBottom()
            })
            .drive(chatTableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        typingField
            .rx
            .text
            .orEmpty
            .map({ text in
                return !text.isEmpty
            })
            .bind(to: viewModel.input.isValidText)
            .disposed(by: bag)
        
        sendButton
            .rx
            .tap
            .map { self.typingField.text ?? "" }
            .do(onNext: { _ in
                self.typingField.text = ""
            })
            .bind(to: viewModel.input.messageInput)
            .disposed(by: bag)
        
        viewModel
            .input
            .viewDidload
            .accept(())
        
    }
    
    func scrollToBottom(isAnimated: Bool = true){
//        DispatchQueue.main.async {
//            // TODO: weak self
//            guard self.viewModel.output.getChatCount > 0 else { return }
//            let indexPath = IndexPath(row: self.viewModel.output.getChatCount - 1, section: 0)
//            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
//        }
    }
    
    @objc func dismissKeyboard() {
        guard self.isTextFieldSelected else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.bottomViewContainer.transform = .identity
            self.chatTableView.transform = .identity
            self.chatTableView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            self.view.endEditing(true)
            self.scrollToBottom()
        })
    }
    
    @IBAction func didTapSettingButton(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Scene.setting.name) as? SettingViewController {
            vc.viewModel = SettingViewModel()
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionDate) as! DateSectionView
        header.setupUI()
        viewModel.output.getChatMessage.drive(onNext: { data in
            header.configDate(date: data[section].header)
        }).disposed(by: bag)
        
        return header
    }
    
}

extension ChatViewController: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        videoPlayer.isHidden = false
        videoPlayer.play()
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        
        switch playerState {
            case .Ended:
                videoPlayer.isHidden = true
            default:
                break
        }
        
    }
    
}
