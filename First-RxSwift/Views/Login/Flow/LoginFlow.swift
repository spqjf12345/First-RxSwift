//
//  LoginFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

class LoginFlow: Flow {
    
    var root: UIViewController {
        return self.rootViewController
    }
    
    private let rootViewController = UINavigationController()
    private let service: LoginJoinService
    
    init(withService service: LoginJoinService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        <#code#>
    }
    
}
