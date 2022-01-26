//
//  SignUpViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class SignUpViewModel {
    let disposeBag = DisposeBag()
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    struct Input {
        let backButton: Observable<Void>
        let idTextfield: Observable<String>
        let checkIDButton: Observable<Void>
        let passwordTextfield: Observable<String>
        let rePasswordTextfield: Observable<String>
        let phoneNumberTextfield: Observable<String>
        let sendMessageButton: Observable<String>
        let authenTextfield: Observable<Void>
        let authenButton: Observable<Void>
        let signUpButton: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>() // alert
        let inValidIDMessage = PublishRelay<String>() // 사용 가능한 아이디입니다., 중복된 아이디가 존재합니다.
        let inValidPWMessage = PublishRelay<Bool>() // true, false
        let sendMessage = PublishRelay<Bool>() // hidden, or not
        let sendAuthenMessage = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.rePasswordTextfield
            .withLatestFrom( Observable.combineLatest(input.passwordTextfield, input.rePasswordTextfield))
            .bind { (pw, repw) in
                if(pw == repw){
                    output.errorMessage.accept("")
                }else {
                    output.errorMessage.accept("비밀번호가 일치하지 않습니다. 다시 입력해주세요")
                }
        }.disposed(by: disposeBag)
        
        
        
        input.idTextfield.subscribe(onNext: { text in
            self.loginUseCase.nickname = text
        }).disposed(by: disposeBag)
        
        input.checkIDButton.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.loginUseCase.checkIdValid()
        }).disposed(by: disposeBag)
        
        let phoneNumber = input.phoneNumberTextfield.subscribe(onNext: { str in }).disposed(by: disposeBag)
        
        input.phoneNumberTextfield
        
//        input.sendMessageButton.subscribe(onNext: { [weak self] in
//            self.loginUseCase.checkAuthenCode(phoneNumber: <#T##String#>)
//        }).disposed(by: disposeBag)
        
        
        self.configureInput(input, disposeBag: disposeBag)
        return createOutput(from: input, disposeBag: disposeBag)

    }
    
    private func configureInput(_ input: Input, disposeBag: DisposeBag){
       
        
    }
    
    private func createOutput(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        self.loginUseCase.nicknameValidationState
            .subscribe(onNext: { [weak self] state in
                if state == .success {
                    output.inValidIDMessage.accept("사용 가능한 아이디입니다.")
                }else {
                    output.inValidIDMessage.accept("중복된 아이디가 존재합니다.")
                }
            }).disposed(by: disposeBag)
        
        
        return output
    }
    
    
}
