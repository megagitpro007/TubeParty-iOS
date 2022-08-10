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
    
    init(repository: TubePartyRepository = TubePartyRepositoryImpl()) {
        self.repository = repository
    }
    
    func uploadImage(image: UIImage, senderID: String, type: UploadImageType) -> Observable<UploadImageResponse> {
        repository.uploadImage(image: image, senderID: senderID, type: type)
    }
    
}
