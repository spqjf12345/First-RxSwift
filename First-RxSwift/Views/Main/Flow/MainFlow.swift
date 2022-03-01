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
    
    let rootViewController = UIPageViewController()
    
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
        let allBoxFlow = AllBoxFlow(withService: self.service)
        let textFlow = TextFlow(withService: self.service)
        let linkFlow = LinkFlow(withService: self.service)
        let giftFlow = GiftFlow(withService: self.service)
        let calendarFlow = CalendarFlow(withService: self.service)
        let settingFlow = SettingFlow(withService: self.service)
        
        Flows.use(allBoxFlow, textFlow, linkFlow, giftFlow, calendarFlow, settingFlow, when: .created) { [unowned self] (root1: UINavigationController, root2: UINavigationController, root3: UINavigationController,root4: UINavigationController,root5: UINavigationController,root6: UINavigationController) in
            root1.title = "보관함"
            root2.title = "텍스트"
            root3.title = "링크"
            root4.title = "선물"
            root5.title = "캘린더"
            root6.title = "설정"
            
            self.rootViewController.setViewControllers([root1, root2, root3, root4, root5, root6], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: allBoxFlow, withNextStepper: OneStepper(withSingleStep: AllStep.boxTap)), .contribute(withNextPresentable: textFlow, withNextStepper: OneStepper(withSingleStep: AllStep.textTap)), .contribute(withNextPresentable: linkFlow, withNextStepper: OneStepper(withSingleStep: AllStep.linkTap)), .contribute(withNextPresentable: giftFlow, withNextStepper: OneStepper(withSingleStep: AllStep.presentTap)), .contribute(withNextPresentable: calendarFlow, withNextStepper: OneStepper(withSingleStep: AllStep.calendarTap)), .contribute(withNextPresentable: settingFlow, withNextStepper: OneStepper(withSingleStep: AllStep.setting))]
    }
    


}
    
