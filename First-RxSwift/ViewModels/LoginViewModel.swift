//
//  LoginViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    
    private let loginUseCase: LoginUseCase
    let disposeBag = DisposeBag()
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    struct Input {
        let idTextField = PublishSubject<String>()
        let passwordTextField = PublishSubject<String>()
        let tapSignInButton = PublishSubject<Void>()
    }
    
    struct Output {
        let enableSignInButton = PublishRelay<Bool>()
        let errorMessage = PublishRelay<String>()
        let goToMain = PublishRelay<Void>()
    }
    
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        Observable.combineLatest(input.idTextField, input.passwordTextField)
            .map{!$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: output.enableSignInButton)
            .disposed(by: disposeBag)
        
        input.tapSignInButton.withLatestFrom( Observable.combineLatest(input.idTextField, input.passwordTextField)).bind { (id, password) in
            if(password.count < 6){
                output.errorMessage.accept("6자리 이상 입력해주세요")
            }else {
                output.goToMain.accept(())
            }
        }.disposed(by: disposeBag)
        return output
    }

}
