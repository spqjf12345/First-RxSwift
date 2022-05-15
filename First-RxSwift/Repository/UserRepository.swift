//
//  UserRepository.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import Foundation
import Moya
import RxSwift

protocol UserRepositoryType {
    func saveLoginInfo(userId: Int32, jwtToken: String)
    func logIn(nickName: String, password: String)
    func signUp(user: SignUpRequest) ->Observable<Int>
    func checkValidId(nickname: String) -> Observable<Int>
    func checkIdValid(nickname: String) -> Observable<Bool>
    func sendMessage(phoneNumber: String) -> Observable<Int>
}

protocol ProfileRepositoryType {
    func getUserInfo() -> Observable<ProfileResponse>
    func logout()
    func changeUserImage(image: Data) -> Observable<Bool>
    func changeUserNickName(nickName: String) -> Observable<Bool>
}

class UserRepository: UserRepositoryType {
    
    let loginJoinService: LoginJoinService
    let profileService: UserProfileService
    
    let disposeBag = DisposeBag()
    
    init(userService: LoginJoinService, profileService: UserProfileService){
        self.loginJoinService = userService
        self.profileService = profileService
    }
    
    func saveLoginInfo(userId: Int32, jwtToken: String) {
        print("save login \(userId) \(jwtToken)")
        UserDefaults.standard.setValue(userId, forKey: UserDefaultKey.userID)
        UserDefaults.standard.setValue(jwtToken, forKey: UserDefaultKey.jwtToken)
    }
    
    func logIn(nickName: String, password: String) {
        loginJoinService.login(nickName: nickName, password: password).subscribe { loginResponse in
            self.saveLoginInfo(userId: loginResponse.userId, jwtToken: loginResponse.jwtToken)
        }.disposed(by: disposeBag)
        
    }
    
    
    func signUp(user: SignUpRequest) -> Observable<Int> {
        return loginJoinService.signUp(user: user)
    }
    
    func checkValidId(nickname: String) -> Observable<Int> {
        return loginJoinService.checkValidId(nickName: nickname)
    }
    
    func checkIdValid(nickname: String) -> Observable<Bool> {
        return loginJoinService.checkIdValid(nickName: nickname)
    }
    
    func sendMessage(phoneNumber: String) -> Observable<Int> {
        return loginJoinService.sendMessage(phoneNumber: phoneNumber)
    }
    
    
    
    
}

extension UserRepository: ProfileRepositoryType {

    func getUserInfo() -> Observable<ProfileResponse> {
        return self.profileService.getUserInfo()
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.phoneNumber)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userID)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.userNickName)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.isNewUser)
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.jwtToken)
    }
    
    func changeUserImage(image: Data) -> Observable<Bool> {
        return profileService.changeImage(image: image)
    }
    
    func changeUserNickName(nickName: String) -> Observable<Bool> {
        return profileService.changeNickName(text: nickName)
    }
    
    
    
    
}
