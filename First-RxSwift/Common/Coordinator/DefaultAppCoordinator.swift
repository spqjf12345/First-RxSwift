//
//  DefaultAppCoordinator.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/24.
//

import Foundation
import UIKit

class DefaultAppCoordinator: AppCoordinator {
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator]
    
    var type: CoordinatorType { .app }
    
    func start() {
        if (UserDefaults.standard.string(forKey: UserDefaultKey.isNewUser) == "1" && UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) != nil) {
            self.showTabBarFlow()
        }else {
            self.showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        //loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = DefaultMainCoordinator()
        //tabBarCoordinator.finishDelegate = self
//        tabBarCoordinator.start()
//        childCoordinators.append(tabBarCoordinator)
    }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
}
