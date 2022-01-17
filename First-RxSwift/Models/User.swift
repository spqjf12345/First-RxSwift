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
    
    init(nickName: String, password: String, email: String, phoneNumber: String) {
        self.nickName = nickName
        self.password = password
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
