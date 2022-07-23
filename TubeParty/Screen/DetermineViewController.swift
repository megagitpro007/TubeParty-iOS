//
//  DetermineViewController.swift
//  TubeParty
//
//  Created by Damrongdech Haemanee on 1/7/2565 BE.
//

import UIKit

class DetermineViewController: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    
    struct Config {
        static let backgroundColor = UIColor.tpGunmetal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepare()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            if let userProfile: UserProfile = UserDefaultsManager.get(by: .userProfile) {
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: Scene.chat.name) as? ChatViewController {
                    vc.viewModel = ChatViewModel(userChatName: userProfile.name)
                    let nav = UINavigationController(rootViewController: vc)
                    self?.replaceRoot(vc: nav)
                }
            } else {
                if let vc = self?.storyboard?.instantiateViewController(withIdentifier: Scene.login.name) as? MainLoginViewController {
                    let nav = UINavigationController(rootViewController: vc)
                    self?.replaceRoot(vc: nav)
                }
            }
        })
    }
    
    func prepare() {
        self.view.backgroundColor = Config.backgroundColor
        self.logo.image = UIImage(named: "logo")
        self.logo.tintColor = .white
        self.logo.layer.shadowColor = UIColor.tpMainGreen.withAlphaComponent(1.0).cgColor
        self.logo.layer.shadowOffset = .init(width: 3, height: 6)
        self.logo.layer.shadowOpacity = 1
        self.logo.layer.shadowRadius = 20
        
        let loading = LoadingView(frame: .zero)
        self.view.addSubview(loading)
        loading.center = self.view.center
    }
}
