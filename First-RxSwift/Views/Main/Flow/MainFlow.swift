//
//  MainFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/02/16.
//

import Foundation
import RxFlow

class MainFlow: Flow {
    var root: Presentable
    
    let rootViewController = UITabBarController()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }

        switch step {
        case .boxTap:
            return navigateToBoxTap()
        default:
            return .none
        }
    }
    
    func navigateToBoxTap() -> FlowContributors {
        let loginFlow = LoginFlow(withService: self.service)
        
        Flows.use(loginFlow, when: .created) { [unowned self] (root1: UINavigationController) in
            root1.title = "보관함"
            self.rootViewController.setViewControllers([root1], animated: false)
        }
        
//        return .multiple(flowContributors: [.contribute(withNextPresentable: wishListFlow,
//                                                        withNextStepper: CompositeStepper(steppers: [OneStepper(withSingleStep: DemoStep.moviesAreRequired), wishlistStepper])),
//                                            .contribute(withNextPresentable: watchedFlow,
//                                                        withNextStepper: OneStepper(withSingleStep: DemoStep.moviesAreRequired)),
//                                            .contribute(withNextPresentable: trendingFlow,
//                                                        withNextStepper: trendingStepper)])
    }
    


}
    
