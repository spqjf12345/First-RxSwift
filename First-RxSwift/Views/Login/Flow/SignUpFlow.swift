//
//  SignUpFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

//class SignUpFlow: Flow {
//    var root: Presentable {
//        return self.rootViewController
//    }
//    
//    private var rootViewController: UINavigationController = {
//        let viewController = UINavigationController()
//        return viewController
//    }()
//    
//    private let service: AppService
//    
//    init(withService service: AppService){
//        print("SignUpFlow  initial")
//        self.service = service
//    }
//    
//    func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? AllStep else { return .none }
//        print("SignUpFlow \(step)")
//        switch step {
//        case .login:
//            return .end(forwardToParentFlowWithStep: AllStep.login)
//        case .signUp:
//            return self.navigateToSignUp()
//        default:
//            return .none
//        }
//    }
//    
//    private func navigateToSignUp() -> FlowContributors {
//        print("SignUpFlow signup")
//        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
//        self.rootViewController = UINavigationController(rootViewController: vc)
//        return .one(flowContributor: .contribute(withNext: vc))
//    }
//    
//    
//    
//    
//}
