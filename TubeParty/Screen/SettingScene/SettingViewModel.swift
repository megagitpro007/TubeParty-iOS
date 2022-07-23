//
//  SettingViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 18/7/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseFirestore

protocol SettingViewModelType {
    var input: SettingInputs { get }
    var output: SettingOutputs { get }
}

protocol SettingInputs {
    var viewDidload: PublishRelay<Void> { get }
    var didNameChange: PublishRelay<String> { get }
    var didTapChangeImage: PublishRelay<Void> { get }
    var didTapSaveButton: PublishRelay<Void> { get }
    var uploadProfileIamge: PublishRelay<UIImage> { get set }
}

protocol SettingOutputs {
    var getCurrentProfile: Driver<UserProfile> { get }
    var showAlertSaved: Driver<Void> { get }
    var uploadPercentage: Driver<Int> { get }
}

final class SettingViewModel: SettingViewModelType, SettingInputs, SettingOutputs {
    
    // IOType
    var input: SettingInputs { return self }
    var output: SettingOutputs { return self }
    
    // Inputs
    var viewDidload: PublishRelay<Void> = .init()
    var didTapChangeImage: PublishRelay<Void> = .init()
    var didTapSaveButton: PublishRelay<Void> = .init()
    var didNameChange: PublishRelay<String> = .init()
    var uploadProfileIamge: PublishRelay<UIImage> = .init()
    
    // Outputs
    var getCurrentProfile: Driver<UserProfile> {
        return _getCurrentProfile
            .asDriver(onErrorDriveWith: .never())
    }
    var showAlertSaved: Driver<Void> {
        return _showAlertSaved
            .asDriver(onErrorDriveWith: .never())
    }
    var uploadPercentage: Driver<Int> {
        return _uploadPercentage
            .asDriver(onErrorDriveWith: .never())
    }
    
    // Properties
    private let _getCurrentProfile: PublishRelay<UserProfile> = .init()
    private let _showAlertSaved: PublishRelay<Void> = .init()
    private let _uploadPercentage: PublishRelay<Int> = .init()
    private let getMessageUseCase: UploadImageUseCaseDomain
    private let bag = DisposeBag()
    
    init() {
        
        getMessageUseCase = TubePartyUseCaseProvider().makeUploadImageUseCaseDomain()
        
        viewDidload.map { _ -> UserProfile in
            if let profile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
                return profile
            }
            return UserProfile.init(name: "", profileURL: "", senderID: "")
        }
        .bind(to: _getCurrentProfile)
        .disposed(by: bag)
        
        didTapSaveButton.withLatestFrom(didNameChange).bind { [weak self] name in
            guard let self = self else { return }
            if name != "" {
                
                if var userProfile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
                    userProfile.name = name
                    UserDefaultsManager.set(userProfile, by: .userProfile)
                }
                
                let firestore = Firestore.firestore()
                
                firestore.collection("message_list")
                    .whereField("sender_id", isEqualTo: "Sjr4PMnyTVDyL7y")
                    .getDocuments() { (querySnapshot, err) in
                        for exx in querySnapshot!.documents {
                            print("🔥exx.documentID : \(exx.documentID)")
                            exx.reference.updateData([
                                "profile_name": "test",
                                "profile_url": "https://pbs.twimg.com/profile_images/1394650755189989377/mYp6yLy-_400x400.jpg"
                            ])
                        }
                        self._showAlertSaved.accept(())
                    }
                
            }
        }.disposed(by: bag)
        
        let uploadImage = uploadProfileIamge.flatMapLatest { [weak self] image -> Observable<Event<Int>> in
            guard let self = self else { return .never() }
            return self.getMessageUseCase.uploadProfileImage(image: image, senderID: "").materialize()
        }
        
        let uploadImageSuccess = uploadImage.compactMap({$0.event.element})
        let uploadImageFail = uploadImage.compactMap({$0.event.error})
        
        uploadImageSuccess
            .bind(to: _uploadPercentage)
            .disposed(by: bag)
        
        uploadImageFail.bind { error in
            print(error.localizedDescription)
        }.disposed(by: bag)
                    
    }
    
}
