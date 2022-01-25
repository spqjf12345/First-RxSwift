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
        print("login flow in step \(step)")
        switch step {
        case .login:
            return self.navigateToLogin()
        case .signUp:
            return .end(forwardToParentFlowWithStep: AllStep.signUp)
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
    
    private func navigateToLogin() -> FlowContributors {"/api/check-nickname"
       //let viewModel = LoginViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
       //return .one(flowContributor: .contribute(withNextPresentable: vc!, withNextStepper: viewModel))

    }

    
    private func navigateToFindID() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindIDViewController") as! FindIDViewController
        rootViewController.pushViewController(vc, animated: true)
        
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToFindPW() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
        rootViewController.pushViewController(vc, animated: true)
        
        return .end(forwardToParentFlowWithStep: AllStep.findPassword)
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
