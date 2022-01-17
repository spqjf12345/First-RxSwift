//
//  User.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation

struct User: Codable {
    let nickName: String
    let password: String
    let email: String
    
    init(nickName: String, password: String, email: String) {
        self.nickName = nickName
        self.password = password
        self.email = email
    }
}
