//
//  UpdateProfileUseCase.swift
//  TubeParty
//
//  Created by iZE Appsynth on 23/7/2565 BE.
//

import FirebaseFirestore
import RxSwift

final public class UpdateProfileUseCase: UpdateProfileUseCaseDomain {
    
    private let repository: TubePartyRepository
    
    init(repository: TubePartyRepository = TubePartyRepositoryImpl()) {
        self.repository = repository
    }
    
    public func updateProfile(userProfile: UserProfile) -> Single<Void> {
        return repository.updateUserProfile(userProfile: userProfile)
    }
    
}
