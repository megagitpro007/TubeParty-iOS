//
//  UpdateProfileUseCaseDomain.swift
//  TubeParty
//
//  Created by iZE Appsynth on 23/7/2565 BE.
//

import RxSwift

public protocol UpdateProfileUseCaseDomain {
    func updateProfile(userProfile: UserProfile) -> Single<Void>
}
