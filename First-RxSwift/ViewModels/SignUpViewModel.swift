//
//  SignUpViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class SignUpViewModel: Stepper {
    var steps = PublishRelay<Step>()
    private let loginUseCase: LoginUseCase
    
    var initialStep: Step {
        return AllStep.signUp
    }
    
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
}
