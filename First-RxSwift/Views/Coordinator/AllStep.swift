//
//  File.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import RxFlow

enum AllStep: Step {
    case popToLogin
    case back
    case login
    case signUp
    case findID
    case findPassword
    
    case makeFolder
    case boxTap
    
    case textTap
    case textIn (folderId: Int)
    case textAdd
    
    case linkTap
    case linkIn (folderId: Int)
    case linkAdd
    
    case presentTap
    case presentAdd
    case showPresentImage
    
    case calendarTap
    case calendarAdd
    
    case setting
    case editProfile
    case bookMark
}
