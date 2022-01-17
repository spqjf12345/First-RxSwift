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
    
}

extension LoginJoinAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/login"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let nickname, let password):
            return .requestParameters(parameters: ["nickname": nickname, "password": password], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["application/json": "Content-Type"]
    }
    
    
    
}
