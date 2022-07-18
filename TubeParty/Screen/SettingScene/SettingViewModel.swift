//
//  SettingViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 18/7/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa

protocol SettingViewModelType {
    var input: SettingInputs { get }
    var output: SettingOutputs { get }
}

protocol SettingInputs {
    var viewDidload: PublishRelay<Void> { get }
    var didTapChangeImage: PublishRelay<Void> { get }
    var didTapSaveButton: PublishRelay<Void> { get }
}

protocol SettingOutputs {
    
}

final class SettingViewModel: SettingViewModelType, SettingInputs, SettingOutputs {
    
    // IOType
    var input: SettingInputs { return self }
    var output: SettingOutputs { return self }
    
    // Inputs
    var viewDidload: PublishRelay<Void> = .init()
    var didTapChangeImage: PublishRelay<Void> = .init()
    var didTapSaveButton: PublishRelay<Void> = .init()
    
    // Outputs
    
}
