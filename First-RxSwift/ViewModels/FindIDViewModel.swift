//
//  FindIDViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class FindIDViewModel: Stepper {
    var steps = PublishRelay<Step>()
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    struct Input {
        let backButton: Observable<Void>
        let phoneTextField: Observable<String>
        let authenRequestButton: Observable<Void>
        let authenTextField: Observable<String>
        let authenButton: Observable<Void>
        let findPWButton: Observable<Void>
        let goToLoginButton: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let sendMessage = BehaviorRelay<Bool>.init(value: false) // hidden, or not
        let authenValid = PublishRelay<String>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.phoneTextField.subscribe(onNext: { number in
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
                output.sendMessage.accept(true) //인증번호를 전송했습니다.
            }
        }).disposed(by: disposeBag)
        
        input.authenButton
            .withLatestFrom(input.authenTextField)
            .bind { code in
                if(Int(code) == self.loginUseCase.authenCode) {
                    output.authenValid.accept("인증이 정상적으로 확인되었습니다.")
                }else {
                    output.authenValid.accept("인증 번호를 다시 입력해주세요.")
                }
            }
            .disposed(by: disposeBag)
        
        return output
        
    }
    
}
