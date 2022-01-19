//
//  SignUpReactor.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import ReactorKit
import RxSwift

enum ValidationResult: Equatable {
    case ok
    case no(_ msg: String)
}

final class SignUpViewReactor:Reactor {
    
    //유저에게 받은 액션 (input)
    enum Action {
        //case inputIdTextField(String?)
        case sameIdCheckButton(String?)
        
        case inputpasswordField(String?)
        case inputRepasswordField
        
        case inputPhoneNumberTextField(String?)
        case authenRequestButton
        
        case inputAuthenCodeTextField(String?)
        case authenCodeCheckButton
        
        case signUpButton
    }
    
    //액션 받은 변화 (output)
    enum Mutation {
        case alertInput([String: String])
        
        case IdValidText(String)
        
        case passwordValidText
        
        case alertInputPhoneNumber
        case sendCodeText
        
        case authenValidText
        
        case alertSignUpDone
        case MoveToLogin
    }
    
    struct State {
        var alertMessage: [String: String]? //title : message
        
        var idValidText: String?
        var passwordValidText: String?
        var sendAuthenCodeText: String?
        var checkCodeText: String?
        var isReady: Bool = false
        
        var validationResult: ValidationResult?
    }
    
    var initialState: State = State()
    
    
    
}

//extension SignUpViewReactor {
//    //Action을 받고, Observable을 생성
//    func mutate(action: Action) -> Observable<Mutation> {
//        switch action {
//        case let .sameIdCheckButton(text):
//            var message: [String: String]
//            if(text?.count == 0) {
//                message = ["아이디 입력": "아이디를 입력해주세요"]
//                return Observable.concat([Observable.just(Mutation.alertInput(message))])
//            }else {
//                //call sameIdCheck
//                //if true
//                var guideMessage = "사용 가능한 아이디입니다."
//                return Observable.concat([Observable.just(Mutation.IdValidText(guideMessage))])
//            }
//        
//            
//        }
//    }
//    
//   
//}
