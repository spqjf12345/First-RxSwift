//
//  ProfileUsecase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/09.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileUsecaseType {
    func getUserInfo()
    func logout()
    func changeImage(image: Data)
    func changeNickName(nickName: String)
}

class ProfileUsecase: ProfileUsecaseType {
    
    var nickName = PublishSubject<String>()
    var imageData = PublishSubject<Data>()
    let userRepository: UserRepository
    let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserInfo() {
        self.userRepository.getUserInfo()
            .subscribe(onNext: { [weak self] userInfo in
                print("get user info \(userInfo)")
                self?.imageData.onNext(userInfo.imageData!)
                self?.nickName.onNext(userInfo.nickname)
            }).disposed(by: disposeBag)
    }
    
    func logout() {
        self.userRepository.logout()
    }
    
    func changeImage(image: Data) {
        self.userRepository.changeUserImage(image: image)
            .filter { $0 == true }
            .subscribe(onNext: { _ in
                self.imageData.onNext(image)
            }).disposed(by: disposeBag)
    }
    
    func changeNickName(nickName: String) {
        self.userRepository.changeUserNickName(nickName: nickName)
            .filter { $0 == true }
            .subscribe(onNext: { _ in
                self.nickName.onNext(nickName)
            }).disposed(by: disposeBag)
    }
    
    
}
