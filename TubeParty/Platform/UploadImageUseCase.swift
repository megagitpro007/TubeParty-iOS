//
//  UploadImageUseCase.swift
//  TubeParty
//
//  Created by iZE Appsynth on 20/7/2565 BE.
//

import Foundation
import FirebaseStorage
import RxSwift

final class UploadImageUseCase: UploadImageUseCaseDomain {
    
    private let repository: TubePartyRepository
    private let firebaseStorage: Storage
    private let storageRef: StorageReference
    
    init(repository: TubePartyRepository = TubePartyRepositoryImpl()) {
        self.repository = repository
        firebaseStorage = Storage.storage()
        storageRef = firebaseStorage.reference()
    }
    
    func uploadFile(image: UIImage, senderID: String) -> Observable<StorageUploadTask> {
        repository.uploadFile(storageRef: storageRef,
                              image: image,
                              senderID: senderID)
    }
    
}
