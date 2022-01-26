//
//  SignUpValidateError.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/26.
//

import Foundation

enum SignUpValidationError: Error {
    case none
    case idTextfield
    case idValid
    case password
    case passwordValid
    case passwordCorrect
    case phoneNumber
    case phoneNumberValid
    case authenCode
    case authenCodeValid
    
    var description: String? {
        var errorMessage: String?
        switch self {
        case .none:
            errorMessage = nil
        case .idTextfield:
            errorMessage = "아이디를 입력해주세요"
        case .idValid:
            errorMessage = "아이디 중복 확인해주세요"
        case .password:
            errorMessage = "비밀번호를 입력해주세요"
        case .passwordValid:
            errorMessage = "비밀번호를 형식에 맞게 입력해주세요"
        case .passwordCorrect:
            errorMessage = "비밀번호가 일치하지 않습니다. 다시 입력해주세요"
        case .authenCode :
            errorMessage = "인증 확인해주세요"
        case .authenCodeValid:
            errorMessage = "인증번호가 일치하지 않습니다."
        case .phoneNumberValid:
            errorMessage = "전화번호는 숫자만 입력해주세요"
        case .phoneNumber:
            errorMessage = "전화번호를 입력해주세요"
        }
        
        return errorMessage
    }
}

