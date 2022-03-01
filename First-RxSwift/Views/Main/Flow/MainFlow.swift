//
//  MainFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/02/16.
//

import Foundation
import RxFlow

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

        switch step {
        case .boxTap:
            return navigateToAllBoxTap()
        default:
            return .none
        }
    }
    
    func navigateToAllBoxTap() -> FlowContributors{
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
        self.rootViewController.pushViewController(vc, animated: true)
        let allBoxFlow = AllBoxFlow(withService: self.service)
        let textFlow = TextFlow(withService: self.service)
        let linkFlow = LinkFlow(withService: self.service)
        let giftFlow = GiftFlow(withService: self.service)
        let calendarFlow = CalendarFlow(withService: self.service)
        //let settingFlow = SettingFlow(withService: self.service)
        
        Flows.use(allBoxFlow, textFlow, linkFlow, giftFlow, calendarFlow, when: .ready) { all, text, link, gift, calendar in
            self.rootViewController.setViewControllers([all, text, link, gift, calendar], animated: false)
            return
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: allBoxFlow, withNextStepper: OneStepper(withSingleStep: AllStep.boxTap)), .contribute(withNextPresentable: textFlow, withNextStepper: OneStepper(withSingleStep: AllStep.textTap)), .contribute(withNextPresentable: linkFlow, withNextStepper: OneStepper(withSingleStep: AllStep.linkTap)), .contribute(withNextPresentable: giftFlow, withNextStepper: OneStepper(withSingleStep: AllStep.presentTap)), .contribute(withNextPresentable: calendarFlow, withNextStepper: OneStepper(withSingleStep: AllStep.calendarTap))])
    }


}
    
