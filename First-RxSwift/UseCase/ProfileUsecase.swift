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
    
}
