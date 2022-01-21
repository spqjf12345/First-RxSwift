//
//  AppFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

class AppFlow: Flow {
    var window: UIWindow
    
    var root: Presentable {
        return self.window
    }
    
    private let service: AppService

    init(service: AppService, window: UIWindow) {
        self.service = service
        self.window = window
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }
        switch step {
        case .login:
            return navigationToLogin()
        case .boxTap:
            return navigateToMain()
        default:
            return .none
        }
    }
    
    private func navigationToLogin() -> FlowContributors {
        
        let loginFlow = LoginFlow(withService: self.service)
        Flows.use(loginFlow, when: .created){ [unowned self] root in
            DispatchQueue.main.async {
                self.window.rootViewController = root
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AllStep.login)))
    }
    
    private func navigateToMain() -> FlowContributors {
        //TODO 수정
        let loginFlow = LoginFlow(withService: self.service)
        Flows.use(loginFlow, when: .created){ [unowned self] root in
            DispatchQueue.main.async {
                self.window.rootViewController = root
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AllStep.login)))
    }
}
