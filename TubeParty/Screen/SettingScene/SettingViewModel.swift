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
import UIKit

enum UploadImageState {
    case process(Percent)
    case finish
}

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

protocol SettingOutputs: BaseOutput {
    var getCurrentProfile: Driver<UserProfile> { get }
    var showAlertSaved: Driver<Void> { get }
    var uploadState: Driver<UploadImageState> { get }
    var uploadedPhoto: Driver<UIImage> { get }
    var error: Driver<Error> { get }
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
    
    var uploadedPhoto: Driver<UIImage> {
        return _uploadedPhoto
            .asDriver(onErrorDriveWith: .never())
    }

    var uploadState: Driver<UploadImageState> {
        return _uploadState
            .asDriver(onErrorDriveWith: .never())
    }
    
    var error: Driver<Error> {
        return _error
            .asDriver(onErrorDriveWith: .never())
    }
    
    // Properties
    private let _getCurrentProfile: PublishRelay<UserProfile> = .init()
    private let _showAlertSaved: PublishRelay<Void> = .init()
    private let _uploadState: PublishRelay<UploadImageState> = .init()
    private let _uploadedPhoto: PublishRelay<UIImage> = .init()
    private let _error: PublishRelay<Error> = .init()
    private let uploadImageUseCase: UploadImageUseCaseDomain
    private let updateProfileUseCase: UpdateProfileUseCaseDomain
    private let bag = DisposeBag()
    
    init() {
        let provider = TubePartyUseCaseProvider()
        uploadImageUseCase = provider.makeUploadImageUseCaseDomain()
        updateProfileUseCase = provider.makeUpdateProfileUseCaseDomain()
        
        viewDidload
            .map { _ in self.getUserProfile() }
            .bind(to: self._getCurrentProfile)
            .disposed(by: self.bag)
        
        didNameChange
            .map { self.getUserProfile(name: $0) }
            .bind(onNext: self.updateUserProfile(_:))
            .disposed(by: self.bag)
        
        uploadProfileIamge
            .map { ($0, self.getUserProfile().senderID) }
            .bind(onNext: { self.updateProfileImage($0, senderId: $1) })
            .disposed(by: self.bag)
    }
    
    private func updateUserProfile(_ userProfile: UserProfile) {
        self.updateProfileUseCase
            .updateProfile(userProfile: userProfile)
            .subscribe(onSuccess: {
                self._showAlertSaved.accept(())
                UserDefaultsManager.set(userProfile, by: .userProfile)
                NSLog("updateProfile: onSuccess")
            }, onFailure: { [weak self] error in
                guard let self = self else { return }
                self._error.accept(error)
            })
            .disposed(by: self.bag)
    }
    
    private func updateProfileImage(_ image: UIImage, senderId: String) {
        self.uploadImageUseCase
            .uploadImage(type: .profile(image: image, senderID: senderId))
            .subscribe(onNext: { [weak self] (percent, imageUrl) in
                guard let self = self else { return }
                self._uploadState.accept(.process(percent))
                if let imageUrl = imageUrl {
                    let userProfile: UserProfile = self.getUserProfile(imageUrl: imageUrl)
                    UserDefaultsManager.set(userProfile, by: .userProfile)
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }
                self._error.accept(error)
            }, onCompleted: { 
                self._uploadState.accept(.finish)
                self._uploadedPhoto.accept(image)
            })
            .disposed(by: self.bag)
    }
    
    private func getUserProfile(name: String? = nil, imageUrl: URL? = nil) -> UserProfile {
        var userProfile: UserProfile = UserDefaultsManager.get(by: .userProfile) ?? .empty()
        if let name = name {
            userProfile.replaceName(name)
        } else if let url = imageUrl {
            userProfile.replaceURL(url)
        }
        return userProfile
    }
}


//        viewDidload.map { _ -> UserProfile in
//            if let profile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
//                return profile
//            }
//            return UserProfile.init(name: "", profileURL: "", senderID: "")
//        }
//        .bind(to: _getCurrentProfile)
//        .disposed(by: bag)
        
//        let updateProfile = didTapSaveButton.withLatestFrom(didNameChange).flatMapLatest { [weak self] name -> Observable<Event<Void>> in
//            guard let self = self else { return .never() }
//            var userprofile = UserProfile(name: "", profileURL: "", senderID: "")
//            if name != "" {
//                if var profile: UserProfile = UserDefaultsManager.get(by:.userProfile) {
//                    profile.name = name
//                    UserDefaultsManager.set(profile, by: .userProfile)
//                    userprofile = profile
//                }
//            }
//            return self.updateProfileUseCase.updateProfile(userProfile: userprofile).materialize()
//        }.share()
//
//        let updateProfileSuccess = updateProfile.compactMap({$0.event.element})
//        let updateProfileFail = updateProfile.compactMap({$0.event.error})
//
//        updateProfileSuccess
//            .bind(to: _showAlertSaved)
//            .disposed(by: bag)
//
//        updateProfileFail.bind { error in
//
//        }.disposed(by: bag)
//
//        let uploadImage = uploadProfileIamge.flatMapLatest { [weak self] image -> Observable<Event<Int>> in
//            guard let self = self else { return .never() }
//            return self.uploadImageUseCase.uploadProfileImage(image: image, senderID: "").materialize()
//        }
//
//        let uploadImageSuccess = uploadImage.compactMap({$0.event.element})
//        let uploadImageFail = uploadImage.compactMap({$0.event.error})
//
//        uploadImageSuccess
//            .bind(to: _uploadPercentage)
//            .disposed(by: bag)
//
//        uploadImageFail.bind { error in
//            print(error.localizedDescription)
//        }.disposed(by: bag)
