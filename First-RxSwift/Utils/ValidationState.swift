//
//  signUpValidate.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/26.
//

import Foundation

enum ValidationState: Equatable {
    case success
    case failure
    
    var description: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
