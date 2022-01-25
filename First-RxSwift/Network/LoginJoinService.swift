//
//  LoginJoinService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import Moya
import RxSwift

protocol HasLoginJoinService {
    var loginJoinService: LoginJoinService { get }
}

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
    
//    func signUp(user: User) -> Observable<Result<Data, Error>> {
//        self.provider.rx.request(.signUp(user: user) { }
//                                 
//        return Observable<Result<Data, Error>>.create { emitter in
//
//        }
//        
//            
//    }
    
    func checkValidId(nickName: String) -> Observable<Int> {
        return self.provider.rx.request(.checkValidID(nickname: nickName))
            .filterSuccessfulStatusCodes()
            .map(Int.self)
            .asObservable()
    }
    
}
