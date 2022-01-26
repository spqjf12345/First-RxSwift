//
//  FindPWFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

//class FindPWFlow: Flow {
//
//    var root: Presentable {
//        return self.rootViewController
//    }
//
//    private lazy var rootViewController: UINavigationController = {
//        let viewController = UINavigationController()
//        return viewController
//    }()
//
//    private let service: AppService
//
//    init(withService service: AppService){
//        self.service = service
//    }
//
//    func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? AllStep else { return .none }
//        switch step {
//        case .login:
//            return .end(forwardToParentFlowWithStep: AllStep.login)
//        case .findPassword:
//            return navigateToFindPW()
//        default:
//            return FlowContributors.none
//        }
//    }
//
//    private func navigateToFindPW() -> FlowContributors {
//        print("FindPWFlow FindPW")
//        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
//        rootViewController.pushViewController(vc, animated: true)
//
//        return .one(flowContributor: .contribute(withNext: vc))
//    }
//
//
//
//}
