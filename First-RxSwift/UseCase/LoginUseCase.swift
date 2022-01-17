//
//  LoginUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
import RxSwift

protocol LoginUseCaseType {
    func saveLoginInfo(requestValue: User)
}

class LoginUseCase: LoginUseCaseType {
    
    
    private let userRepository: UserRepository
    var disposeBag = DisposeBag()
    
    init(repository: UserRepository) {
        self.userRepository = repository
    }
    
    func saveLoginInfo(requestValue: User) {
        userRepository.saveLoginInfo(userId: requestValue.id, phoneNumber: requestValue.phoneNumber, nickName: requestValue.nickName)
    }
    
    
    
    
}
