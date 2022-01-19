//
//  LoginFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

class LoginFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }
        switch step {
        case .signUp:
            return self.navigateToSignUp()
        case .findID:
            return self.navigateToFindID()
        case .findPassword:
            return self.navigateToFindPW()
        case .boxTap:
            return self.navigateToMain()
        default:
            return FlowContributors.none
        }
    }
    
    private func navigateToSignUp() -> FlowContributors {
        let viewModel = SignUpViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        let signUpFlow = SignUpFlow(withService: self.service)
        Flows.use(signUpFlow, when: .ready) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: signUpFlow, withNextStepper: viewModel))
    }
    
    private func navigateToFindID() -> FlowContributors {
        let viewModel = FindIDViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        let findIDFlow = FindIDFlow(withService: self.service)
        Flows.use(findIDFlow, when: .ready) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: findIDFlow, withNextStepper: viewModel))
    }
    
    private func navigateToFindPW() -> FlowContributors {
        let viewModel = FindPWViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        let findPWFlow = FindPWFlow(withService: self.service)
        Flows.use(findPWFlow, when: .ready) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: findPWFlow, withNextStepper: viewModel))
    }
    
    private func navigateToMain() -> FlowContributors {
        //TODO
        let viewModel = FindIDViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        let findIDFlow = FindIDFlow(withService: self.service)
        Flows.use(findIDFlow, when: .ready) { [unowned self] root in
            self.rootViewController.pushViewController(root, animated: true)
        }
        return .one(flowContributor: .contribute(withNextPresentable: findIDFlow, withNextStepper: viewModel))
    }
    
}
