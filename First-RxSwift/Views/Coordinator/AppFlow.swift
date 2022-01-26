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
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
   
    
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
        print("initial --")
        let loginFlow = LoginFlow(withService: self.service)
        Flows.use(loginFlow, when: .created){ [unowned self] root in
            DispatchQueue.main.async {
                self.window.rootViewController = root
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: AllStep.login)))
    }
    
//    public func navigateToSignUp() -> FlowContributors {
//        let signUpFlow = SignUpFlow(withService: self.service)
//        Flows.use(signUpFlow, when: .ready){ [unowned self] root in
//            DispatchQueue.main.async {
//                self.rootViewController.pushViewController(root, animated: false)
//            }
//        }
//        return .one(flowContributor: .contribute(withNextPresentable: signUpFlow,
//                                                 withNextStepper: OneStepper(withSingleStep: AllStep.signUp)))
//    }
//
//    public func navigateToFindPW() -> FlowContributors {
//        let findPWFlow = FindPWFlow(withService: self.service)
//        Flows.use(findPWFlow, when: .ready){ [unowned self] root in
//            DispatchQueue.main.async {
//                self.rootViewController.pushViewController(root, animated: false)
//            }
//        }
//        return .one(flowContributor: .contribute(withNextPresentable: findPWFlow,
//                                                 withNextStepper: OneStepper(withSingleStep: AllStep.findPassword)))
//    }
    
    
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
