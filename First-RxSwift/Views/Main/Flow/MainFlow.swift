//
//  MainFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/02/16.
//

import Foundation
import RxFlow
import UIKit

class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }
        print("main flow \(step)")
        switch step {
        case .boxTap:
            return navigateToAllBoxTap()
        default:
            return .none
        }
    }
    
    func navigateToAllBoxTap() -> FlowContributors {
        
//        let viewController = TrendingViewController.instantiate(withViewModel: TrendingViewModel())
//        viewController.title = "Trending"
//        self.rootViewController.pushViewController(viewController, animated: true)
//
//        let trendingFlow = TrendingMovieFlow(withServices: self.services)
//        let castListFlow = CastListFlow(withServices: self.services)
//
//        Flows.use(trendingFlow, castListFlow, when: .ready) { trendingRoot, castListRoot in
//            viewController.nestedViewControllers = [trendingRoot, castListRoot]
//        }
//
//        return .multiple(flowContributors: [.contribute(withNextPresentable: trendingFlow,
//                                                        withNextStepper: OneStepper(withSingleStep: DemoStep.moviesAreRequired),
//                                                        allowStepWhenDismissed: true),
//                                            .contribute(withNextPresentable: castListFlow,
//                                                        withNextStepper: OneStepper(withSingleStep: DemoStep.castListAreRequired),
//                                                        allowStepWhenDismissed: true)])
//
        
        let vc = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.rootViewController.pushViewController(vc, animated: true)
        
        let allBoxFlow = AllBoxFlow(withService: self.service)
        let textFlow = TextFlow(withService: self.service)
        let linkFlow = LinkFlow(withService: self.service)
        let giftFlow = GiftFlow(withService: self.service)
        let calendarFlow = CalendarFlow(withService: self.service)
        //let profileFlow = ProfileFlow(withService: self.service)
        
        Flows.use(allBoxFlow, textFlow, linkFlow, giftFlow, calendarFlow, when: .ready) { all, text, link, gift, calendar in
            vc.nestedViewControllers = [all, text, link, gift, calendar]
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: allBoxFlow, withNextStepper: OneStepper(withSingleStep: AllStep.boxTap)), .contribute(withNextPresentable: textFlow, withNextStepper: OneStepper(withSingleStep: AllStep.textTap)), .contribute(withNextPresentable: linkFlow, withNextStepper: OneStepper(withSingleStep: AllStep.linkTap)), .contribute(withNextPresentable: giftFlow, withNextStepper: OneStepper(withSingleStep: AllStep.presentTap)), .contribute(withNextPresentable: calendarFlow, withNextStepper: OneStepper(withSingleStep: AllStep.calendarTap))])
    }


}
    
