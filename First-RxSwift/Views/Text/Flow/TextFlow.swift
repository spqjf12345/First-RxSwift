//
//  TextFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/01.
//

import Foundation
import RxFlow

class TextFlow: Flow {
    
    var root: Presentable
    
    let rootViewController = UITabBarController()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        return .none
    }
}
