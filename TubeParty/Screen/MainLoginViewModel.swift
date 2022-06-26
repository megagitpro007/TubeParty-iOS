//
//  MainLoginViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 25/6/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa

enum ErrorStateType {
    case empty
}

protocol MainLoginIOType {
    var input: MainLoginInput { get }
    var output: MainLoginOutput { get }
}

protocol MainLoginInput {
    var didTapEnterButton: PublishRelay<Void> { get }
    var textFieldData: PublishRelay<String> { get }
}

protocol MainLoginOutput {
    var errorState: Driver<ErrorStateType> { get }
}

class MainLoginViewModel: MainLoginIOType, MainLoginInput, MainLoginOutput {
    
    // IO Type
    var input: MainLoginInput { return self }
    var output: MainLoginOutput { return self }
    
    // Inputs
    var didTapEnterButton: PublishRelay<Void> = .init()
    var textFieldData: PublishRelay<String> = .init()
    
    // Outputs
    var errorState: Driver<ErrorStateType> { return .never() }
    
    // Properties
    let bag = DisposeBag()
    
    init() {
        textFieldData.bind { txt in
            print("txt : \(txt)")
        }.disposed(by: bag)
        
        didTapEnterButton.bind { _ in
            
        }.disposed(by: bag)
    }
    
}
