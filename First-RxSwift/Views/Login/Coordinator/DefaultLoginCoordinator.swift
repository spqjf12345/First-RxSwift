//
//  DefaultLoginCoordinator.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/24.
//

import UIKit

protocol LoginCoordinator: Coordinator {
    func showSingUpFlow()
    func showFindIDFlow()
    func showFindPWFlow()
    func showTabFlow()
}

class DefaultLoginCoordinator: LoginCoordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var loginViewController: LoginViewController
    var childCoordinators: [Coordinator]
    
    var type: CoordinatorType { .login }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginViewController = LoginViewController()
    }
    
    func start() {
        self.loginViewController.viewModel = LoginViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
        self.navigationController.viewControllers = [self.loginViewController]
    }
    
    func showSingUpFlow() {
        <#code#>
    }
    
    func showFindIDFlow() {
        <#code#>
    }
    
    func showFindPWFlow() {
        <#code#>
    }
    
    func showTabFlow() {
        <#code#>
    }
    
    


    
}
