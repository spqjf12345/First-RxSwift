//
//  User.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation

struct User: Codable {
    let id: Int32
    let nickName: String
    let password: String
    let phoneNumber: String
    
    init(id: Int32 = 0, nickName: String = "", password: String = "", phoneNumber: String = "") {
        self.id = id
        self.nickName = nickName
        self.password = password
        self.phoneNumber = phoneNumber
    }
}

struct LoginResponse: Codable {
    var userId: Int32
    var jwtToken: String
}

struct SignUpRequest: Codable {
    var nickname: String
    var password: String
    var phone: String
}

