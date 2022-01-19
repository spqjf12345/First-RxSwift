//
//  AppStepper.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import RxSwift
import RxFlow
import RxCocoa

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

    var initialStep: Step {
        if(UserDefaults.standard.string(forKey: UserDefaultKey.isNewUser) == "1" && UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) != nil) {
            return AllStep.boxTap
        }else {
            return AllStep.login
        }
    }
}
