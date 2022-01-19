//
//  AppFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow

class AppFlow: Flow {
    var window: UIWindow
    
    var root: Presentable {
        return self.window
    }
    
    init(window: UIWindow){
        self.window = window
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return }
        switch step {
        case .login:
            return self.navigateToLogin()
        case .signUp:
            return self.navigateToSignUp()
        case .findID:
            return self.navigateToFindID()
        case .findPassword:
            return self.navigateToFindPW()
        case .makeFolder:
            return self.navigateToMakeFolder()
        case .boxTap:
            return self.navigateToMain()
        case .textTap:
            return self.navigateToTextTap()
        case .textIn:
            return self.navigateToTextIn()
        case .textAdd:
            return self.navigateToTextAdd()
        case .linkTap:
            return self.navigateToLinkTap()
        case .linkIn:
            return self.navigateToLinkIn()
        case .linkAdd:
            return self.navigateToLinkAdd()
        case .presentTap:
            return self.navigateToPresentTap()
        case .presentAdd:
            return self.navigateToPresentAdd()
        case .showPresentImage:
            return self.navigateToPresentImage()
        case .calendarTap:
            return self.navigateToCalendarTap()
        case .calendarAdd:
            return self.navigateToCalendarAdd()
        case .setting:
            return self.navigateToSetting()
        case .editProfile:
            return self.navigateToEditPfofile()
        case .bookMark:
            return self.navigateToBookMark()
        }
    }
}
