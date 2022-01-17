//
//  UserRepository.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
protocol UserRepositoryType {
    func saveLoginInfo(userId: Int32, phoneNumber: String, nickName: String)
}

class UserRepository: UserRepositoryType {
    
    func saveLoginInfo(userId: Int32, phoneNumber: String, nickName: String) {
        UserDefaults.standard.setValue(userId, forKey: UserDefaultKey.userID)
        UserDefaults.standard.setValue(phoneNumber, forKey: UserDefaultKey.phoneNumber)
        UserDefaults.standard.setValue(nickName, forKey: UserDefaultKey.userNickName)
    }
    
    
}
