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
    func checkValidID(_: String) -> Observable<Int>
    func checkIdValid()
}

class LoginUseCase: LoginUseCaseType {
    
    private let userRepository: UserRepositoryType
    var nicknameValidationState = BehaviorSubject<ValidationState>(value: .failure)
    var passwordValidationState = BehaviorSubject<ValidationState>(value: .failure)
    
    var nickname: String = ""
    var authenCode: Int = 0
    var phoneNumber: String = ""
    var password: String = ""
    var setPassword: String = ""
    
    var disposeBag = DisposeBag()
    
    init(repository: UserRepositoryType) {
        self.userRepository = repository
    }
    
    public func logIn(_ requestValue: User) {
        userRepository.logIn(nickName: requestValue.nickName, password: requestValue.password)
    }
    
    public func checkValidID(_ nickname: String) -> Observable<Int> { //findPW
        return userRepository.checkValidId(nickname: nickname)
    }
    
    public func checkIdValid() { //signup
        return userRepository.checkIdValid(nickname: self.nickname)
            .subscribe(onNext:  { valid in
                if valid {
                    self.nicknameValidationState.onNext(.success)
                }else {
                    self.nicknameValidationState.onNext(.failure)
                }
            }).disposed(by: disposeBag)
    }
    
    public func checkAuthenCode() {
        let number = phoneNumberDashString() // -지운 전화 번호
        self.phoneNumber = number
        return userRepository.sendMessage(phoneNumber: phoneNumber).subscribe(onNext: {
            code in
            self.authenCode = code
        }).disposed(by: disposeBag)
    }
    
    public func validPhoneNumber(number: String) -> Bool {
        if(number.count != 13){
            return false
        }
        if(number[number.index(number.startIndex, offsetBy: 3)] != "-" || number[number.index(number.startIndex, offsetBy: 8)] != "-" ){
            return false
        }
        
        let rangeOfInitial = number.startIndex..<number.index(number.startIndex, offsetBy: 3)
        if(number[rangeOfInitial] != "010"){
            return false
        }
        return true
    }
    
    public func phoneNumberDashString() -> String {
        var number = self.phoneNumber
        number.remove(at: number.index(number.startIndex, offsetBy: 3))
        number.remove(at: number.index(number.startIndex, offsetBy: 7))
        return number
    }
    
    func validpassword(mypassword : String) -> Bool {//숫자+문자 포함해서 8~20글자 사이의 text 체크하는 정규표현식
        let passwordreg = ("(?=.*[A-Za-z])(?=.*[0-9]).{8,20}")
        let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
        return passwordtesting.evaluate(with: mypassword)
    }
    
    
    public func signUp() -> Observable<Error> {
        return self.signInValidCheck()
    }
    
    private func signUpUser() -> Observable<Int> {
        let userData = SignUpRequest(nickname: self.nickname, password: self.password, phone: self.phoneNumber)
        return self.userRepository.signUp(user: userData)
    }
    
    func signInValidCheck() -> Observable<Error> {
        if(self.nickname == ""){
            return Observable.error(SignUpValidationError.idTextfield)
        }
        
//        if(IDValidText.isHidden == true){
//            throw SignInError.idValid
//        }
        
        if(self.password == ""){
            return Observable.error(SignUpValidationError.password)
        }
        
//        if(PasswordInValidText.isHidden == false){
//            throw SignInError.passwordCorrect
//        }
        
        if(validpassword(mypassword: password) == false){
            return Observable.error(SignUpValidationError.passwordValid)
        }
        
//        if(phoneNumberGuideText.isHidden == true){
//            throw SignInError.phoneNumber
//        }
        
        if(phoneNumber != phoneNumberDashString()){
            return Observable.error(SignUpValidationError.phoneNumber)
        }
        
//        if(authenValidText.isHidden == true){
//            throw SignInError.authenCode
//        }
        return Observable.error(SignUpValidationError.none)
        
    }
    
    
}
