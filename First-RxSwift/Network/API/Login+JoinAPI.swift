//
//  LoginAPI.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
import Moya

enum LoginJoinAPI {
    case login(nickname: String, password: String)
    case sameIdCheck(nickname: String)
    case signUp(user: User)
    case checkValidID(nickname: String)
    case checkIDValid(nickname: String)
    case sendMessage(number: String)
}

extension LoginJoinAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login"
        case .sameIdCheck:
            return "/api/duplicate"
        case .signUp:
            return "/api/signup"
        case .checkValidID:
            return "/api/check-nickname"
        case .checkIDValid:
            return "/api/duplicate"
        case .sendMessage:
            return "/api/send-sms"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .sameIdCheck, .signUp, .checkValidID, .checkIDValid:
            return .post
        case .sendMessage:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .login(let nickname, let password):
            return .requestParameters(parameters: ["nickname": nickname, "password": password], encoding: JSONEncoding.default)
        case .sameIdCheck(let nickname):
            return .requestParameters(parameters: ["nickname": nickname], encoding: JSONEncoding.default)
        case .signUp(let user):
            return .requestParameters(parameters: ["nickname": user.nickName, "password" : user.password, "phone" : user.phoneNumber], encoding: JSONEncoding.default)
        case .checkValidID(let nickname):
            return .requestParameters(parameters: ["nickname": nickname] , encoding: JSONEncoding.default)
            
        case .checkIDValid(let nickname):
            return .requestParameters(parameters: ["nickname": nickname] , encoding: JSONEncoding.default)
        case .sendMessage(let number):
            return .requestParameters(parameters: ["toNumber": number], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    
    
}
