//
//  MainLoginViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 25/6/2565 BE.
//

import Foundation
import RxSwift
import RxCocoa

protocol MainViewControllerDelegate {
    func didTapEnterButton()
}

protocol MainLoginIOType {
    var input: MainLoginInput { get }
    var output: MainLoginOutput { get }
    var delegate: MainViewControllerDelegate? { get set }
}

protocol MainLoginInput {
    var didTapEnterButton: PublishRelay<Void> { get }
    var isValidName: PublishRelay<Bool> { get }
    var userChatName: BehaviorRelay<String> { get }
}

protocol MainLoginOutput {
    var showErrorState: Driver<Bool> { get }
}

public class MainLoginViewModel: MainLoginIOType, MainLoginInput, MainLoginOutput {
    
    // IO Type
    var input: MainLoginInput { return self }
    var output: MainLoginOutput { return self }
    var delegate: MainViewControllerDelegate?
    
    // Inputs
    var didTapEnterButton: PublishRelay<Void> = .init()
    var isValidName: PublishRelay<Bool> = .init()
    var userChatName: BehaviorRelay<String> = .init(value: "")
    
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
        
        didTapEnterButton.bind { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.didTapEnterButton()
        }.disposed(by: bag)
        
    }
    
}
