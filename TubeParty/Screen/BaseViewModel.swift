//
//  BaseViewModel.swift
//  TubeParty
//
//  Created by iZE Appsynth on 10/8/2565 BE.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol BaseOutput {
    var error: Driver<Error> { get }
}
