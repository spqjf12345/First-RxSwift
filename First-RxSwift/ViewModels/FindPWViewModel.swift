//
//  FindPWViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class FindPWViewModel: Stepper {
    var steps = PublishRelay<Step>()
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
}
