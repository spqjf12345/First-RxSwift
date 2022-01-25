//
//  FindPWViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxFlow
import RxSwift
import RxCocoa

class FindPWViewModel: Stepper {
    var steps = PublishRelay<Step>()
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }
    
    let disposeBag = DisposeBag()

    
    struct Input {
        let backButton: Observable<Void>
        let idTextfield: Observable<String>
        let checkIDButton: Observable<Void>
        let phoneNumberTextfield: Observable<String>
        let sendMessageButton: Observable<String>
        let authenTextfield: Observable<Void>
        let authenButton: Observable<Void>
        let goToLoginButton: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>() // alert
        let inValidIDMessage = PublishRelay<Bool>() // true, false
        let sendMessage = PublishRelay<Bool>() // hidden, or not
        let sendAuthenMessage = PublishRelay<Bool>()
    }
    
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.checkIDButton // 체크 버튼 눌렀을때 아이디 값이 없으면 에러 메세지 true 하기
            .withLatestFrom(input.idTextfield)
            .bind { textfield in
                if textfield.isEmpty {
                    output.errorMessage.accept("아이디를 입력해주세요")
                }else {
                    //call network
                    self.loginUseCase.checkValidID(nickname: textfield)
                        .subscribe{onNext: value in
                        if value == -1 {
                            output.errorMessage.accept("존재하지 않는 아이디입니다.")
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
       

        return output
    }

    
}
