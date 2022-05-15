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
}

class ProfileUsecase: ProfileUsecaseType {
    
    var nickName: String?
    var imageData = PublishSubject<Data>()
    let userRepository: UserRepository
    let disposeBag = DisposeBag()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func getUserInfo() {
        self.userRepository.getUserInfo()
            .subscribe(onNext: { [weak self] userInfo in
                self?.imageData.onNext(userInfo.imageData ?? Data())
            }).disposed(by: disposeBag)
    }
    
}
