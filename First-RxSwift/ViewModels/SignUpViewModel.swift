//
//  SignUpViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
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
        let authenRequestButton: Observable<Void>
        let authenTextfield: Observable<String>
        let authenButton: Observable<Void>
        let signUpButton: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>() // alert
        let inValidIDMessage = PublishRelay<String>() // 사용 가능한 아이디입니다., 중복된 아이디가 존재합니다.
        let inValidPWMessage = PublishRelay<String>() //
        let sendMessage = PublishRelay<Bool>() // hidden, or not
        let inValidAuthenCode = PublishRelay<String>() //인증이 정상적으로 확인되었습니다, 인증 번호를 다시 입력해주세요.
        let signUpButtonEnable = BehaviorRelay<Bool>.init(value: false)
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.idTextfield.subscribe(onNext: { text in
            self.loginUseCase.nickname = text
        }).disposed(by: disposeBag)
        
        input.checkIDButton.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if(self.loginUseCase.nickname == ""){
                print("here")
                output.errorMessage.accept("아이디를 입력해주세요")
            }
            else {
                self.loginUseCase.checkIdValid()
            }
            
        }).disposed(by: disposeBag)
        
        self.loginUseCase.nicknameValidationState
            .subscribe(onNext: { state in
                if state == .success {
                    output.inValidIDMessage.accept("사용 가능한 아이디입니다.")
                }else if state == .failure {
                    output.inValidIDMessage.accept("중복된 아이디가 존재합니다.")
                }
            })
            .disposed(by: disposeBag)
        
        
        input.passwordTextfield.subscribe(onNext: { password in
            self.loginUseCase.password = password
        }).disposed(by: disposeBag)
        
        input.rePasswordTextfield
            .withLatestFrom( Observable.combineLatest(input.passwordTextfield, input.rePasswordTextfield))
            .bind { (pw, repw) in
                if(pw == repw){
                    output.inValidPWMessage.accept("")
                }else {
                    output.inValidPWMessage.accept("비밀번호가 일치하지 않습니다. 다시 입력해주세요")
                }
        }.disposed(by: disposeBag)
        
        input.phoneNumberTextfield.subscribe(onNext: { number in
            self.loginUseCase.phoneNumber = number
        }).disposed(by: disposeBag)
        
        input.authenRequestButton.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if(self.loginUseCase.phoneNumber == ""){
                output.errorMessage.accept("핸드폰 번호를 입력해주세요")
            }else if(self.loginUseCase.validPhoneNumber(number: self.loginUseCase.phoneNumber) == false){
                output.errorMessage.accept("전화번호 형식이 맞지 않습니다. 다시 입력해주세요")
            }else{
                self.loginUseCase.checkAuthenCode()
                output.sendMessage.accept(true)
            }
        }).disposed(by: disposeBag)
        
        input.authenButton
            .withLatestFrom(input.authenTextfield)
            .bind { code in
                if(Int(code) == self.loginUseCase.authenCode) {
                    output.inValidAuthenCode.accept("인증이 정상적으로 확인되었습니다.")
                }else {
                    output.inValidAuthenCode.accept("인증 번호를 다시 입력해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        input.signUpButton
            .subscribe(onNext: {[weak self] in
                self?.loginUseCase.signUp()
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { _ in
                        output.signUpButtonEnable.accept(true)
                    }, onError: { error in
                        guard let error = error as? SignUpValidationError else { return }
                        output.errorMessage.accept(error.description ?? "")
                        output.signUpButtonEnable.accept(false)
                    }).disposed(by: disposeBag)
                    
            }).disposed(by: disposeBag)
        
        return output

    }
    
    
}
