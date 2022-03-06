//
//  AllBoxFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/01.
//

import Foundation
import RxFlow

class AllBoxFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }
        print("boxTap flow in step \(step)")
        switch step {
        case .boxTap:
            return navigateToBoxTap()
        case .textIn:
            return navigateToTextIn()
        case .linkIn:
            return navigateToLinkIn()
        default:
            return .none
        }
    }
    
    private func navigateToBoxTap() -> FlowContributors {
        let vc = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToTextIn() -> FlowContributors {
        let vc = UIStoryboard(name: "Phrase", bundle: nil).instantiateViewController(withIdentifier: "TextInViewController") as! TextInViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToLinkIn() -> FlowContributors {
        let vc = UIStoryboard(name: "Link", bundle: nil).instantiateViewController(withIdentifier: "LinkInViewController") as! LinkInViewController
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
}
