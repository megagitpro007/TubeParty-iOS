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
    var isValidName: PublishRelay<Bool> { get }
}

protocol MainLoginOutput {
    var showErrorState: Driver<Bool> { get }
}

class MainLoginViewModel: MainLoginIOType, MainLoginInput, MainLoginOutput {
    
    // IO Type
    var input: MainLoginInput { return self }
    var output: MainLoginOutput { return self }
    
    // Inputs
    var didTapEnterButton: PublishRelay<Void> = .init()
    var isValidName: PublishRelay<Bool> = .init()
    
    // Outputs
    var showErrorState: Driver<Bool> {
        return _showErrorState.asDriver(onErrorJustReturn: true)
    }
    
    // Properties
    var _showErrorState: PublishRelay<Bool> = .init()
    
    let bag = DisposeBag()
    
    init() {
        
        isValidName.bind { [weak self] isValidName in
            guard let self = self else { return }
            self._showErrorState.accept(isValidName)
        }.disposed(by: bag)
        
        
        didTapEnterButton.bind { _ in
            
        }.disposed(by: bag)
    }
    
}
