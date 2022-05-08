//
//  LoginJoinService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import Moya
import RxSwift

class LoginJoinService {
    let provider = MoyaProvider<LoginJoinAPI>()
    
    func login(nickName: String, password: String) -> Observable<LoginResponse> {
        return self.provider.rx.request(.login(nickname: nickName, password: password))
            .filterSuccessfulStatusCodes()
            .map(LoginResponse.self)
            .asObservable()
      
    }
    
    func sameIdCheck(nickName: String) -> Observable<Bool> {
        return self.provider.rx.request(.sameIdCheck(nickname: nickName))
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
            .asObservable()
    }
    
    func signUp(user: SignUpRequest) -> Observable<Int> {
        return self.provider.rx.request(.signUp(user: user))
            .filterSuccessfulStatusCodes()
            .map(Int.self)
            .asObservable()
    }
     
    func checkValidId(nickName: String) -> Observable<Int> { // pw 찾을시
        return self.provider.rx.request(.checkValidID(nickname: nickName))
            .filterSuccessfulStatusCodes()
            .map(Int.self)
            .asObservable()
    }
    
    func checkIdValid(nickName: String) -> Observable<Bool> { // signup 시
        return self.provider.rx.request(.checkIDValid(nickname: nickName))
            .filterSuccessfulStatusCodes()
            .map(Bool.self)
            .asObservable()
    }
    
    func sendMessage(phoneNumber: String) -> Observable<Int> { // 인증 번호 전송
        return self.provider.rx.request(.sendMessage(number: phoneNumber))
            .filterSuccessfulStatusCodes()
            .map(Int.self)
            .asObservable()
    }
    
}
