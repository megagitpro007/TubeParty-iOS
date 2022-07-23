//
//  UploadImageUseCaseDomain.swift
//  TubeParty
//
//  Created by iZE Appsynth on 20/7/2565 BE.
//

import RxSwift
import FirebaseStorage

public protocol UploadImageUseCaseDomain {
    func uploadFile(image: UIImage, senderID: String) -> Observable<Percent>
}
