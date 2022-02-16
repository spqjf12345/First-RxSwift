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
        case .popToLogin:
            return self.popToLogin()
        case .signUp:
            //return .end(forwardToParentFlowWithStep: AllStep.signUp)
            return self.navigateToSignUp()
        case .findID:
            return self.navigateToFindID()
        case .findPassword:
            return self.navigateToFindPW()
        case .boxTap:
            return self.navigateToMain()
        case .back:
            return self.navigateBack()
        default:
            return FlowContributors.none
        }
    }
    
    private func navigateToLogin() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
       //return .one(flowContributor: .contribute(withNextPresentable: vc!, withNextStepper: viewModel))

    }
    
    private func navigateToSignUp() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }

    
    private func navigateToFindID() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindIDViewController") as! FindIDViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToFindPW() -> FlowContributors {
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func popToLogin() -> FlowContributors {
        print("login flow navigation to back")
        self.rootViewController.popToRootViewController(animated: true)
        return .none
    }
    
    private func navigateBack() -> FlowContributors {
        print("login flow navigation to back")
        self.rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func navigateToMain() -> FlowContributors {
        //TODO
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
}
