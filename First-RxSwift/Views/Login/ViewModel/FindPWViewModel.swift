//
//  FindPWViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation
import RxSwift
import RxCocoa

class FindPWViewModel {

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
        let sendMessageButton: Observable<Void>
        let authenTextfield: Observable<String>
        let authenButton: Observable<Void>
        let goToLoginButton: Observable<Void>
        let passwordTextfield: Observable<String>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>() // alert
        let inValidIDMessage = BehaviorRelay<Bool>.init(value: false) // true, false
        let sendMessage = PublishRelay<Bool>() // hidden, or not
        let sendAuthenMessage = PublishRelay<String>()
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
                    self.loginUseCase.checkValidID(textfield)
                        .subscribe(onNext : { value in
                            if(value == -1){
                                output.inValidIDMessage.accept(true)
                            }else {
                                output.inValidIDMessage.accept(false)
                            }
                        }).disposed(by: disposeBag)

                }
            }
            .disposed(by: disposeBag)
        
        input.sendMessageButton.subscribe(onNext: { [weak self] _ in
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
            .withLatestFrom(input.authenTextfield)
            .bind { code in
                if(Int(code) == self.loginUseCase.authenCode) {
                    output.sendAuthenMessage.accept("인증이 정상적으로 확인되었습니다.")
                    //alertNewPassWord(title: "새 비밀번호 입력", message: "새 비밀번호를 입력해주세요")
                }else {
                    output.sendAuthenMessage.accept("인증 번호를 다시 입력해주세요.")
                }
            }
            .disposed(by: disposeBag)
        

        return output
    }
    
//    func alertNewPassWord(title: String, message: String){
//        let alertVC = UIAlertController(title: title, message: nil, preferredStyle: .alert)
//
//        alertVC.addTextField(configurationHandler: { (textField) -> Void in
//            self.passwordTextField = textField
//            self.passwordTextField.placeholder = message
//        })
//        let label = UILabel(frame:CGRect(x: 0, y: 40, width: 270, height:18))
//
//        let OKAction = UIAlertAction(title: "확인", style: .default, handler: { [self] (action) -> Void in
//            if let userInput = self.passwordTextField.text  {
//
//
//                label.isHidden = true
//
//                label.textColor = .red
//                label.font = label.font.withSize(12)
//                label.textAlignment = .center
//                label.text = ""
//                alertVC.view.addSubview(label)
//
//                if userInput == "" {
//                    label.text = "비밀번호를 입력해주세요"
//                    label.isHidden = false
//                    self.present(alertVC, animated: true, completion: nil)
//
//                }
//                else {
//                    if(validpassword(mypassword: userInput) == true) {
//                        alertRePassWord(title: "새 비밀번호 입력", message: "한번 더 입력해주세요")
//                    }else{
//                        alertViewController(title: "비밀번호 변경 실패", message: "숫자와 문자를 포함해서 8 ~ 20글자 사이로 입력해주세요", completion: { (response) in})
//                    }
//
//                }
//
//            }
//
//        })
//
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        alertVC.addAction(OKAction)
//        alertVC.addAction(cancelAction)
//        self.present(alertVC, animated: true, completion: nil)
//    }

    
}
