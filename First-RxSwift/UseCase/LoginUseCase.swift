//
//  LoginUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
import RxSwift

protocol LoginUseCaseType {
    func logIn(_: User)
}

class LoginUseCase: LoginUseCaseType {
    
    private let userRepository: UserRepository
    var disposeBag = DisposeBag()
    
    init(repository: UserRepository) {
        self.userRepository = repository
    }
    
    public func logIn(_ requestValue: User) {
        userRepository.logIn(nickName: requestValue.nickName, password: requestValue.password)
    }
    
//    public func signUp(_requestValue: User) {
//        userRepository.signUp(requestValue)
//    }
    
    
    
}
