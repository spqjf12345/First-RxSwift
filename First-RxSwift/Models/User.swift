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
    let email: String
    let phoneNumber: String
    
    init(id: Int32 = 0, nickName: String = "", password: String = "", email: String = "", phoneNumber: String = "") {
        self.id = id
        self.nickName = nickName
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
    }
}

struct LoginResponse: Codable {
    var userId: Int32
    var jwtToken: String
}

