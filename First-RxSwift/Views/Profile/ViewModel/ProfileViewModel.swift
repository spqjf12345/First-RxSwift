//
//  ProfileViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/09.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileViewModel {
    let profileUsecase: ProfileUsecase
    
    let disposeBag = DisposeBag()
    
    init(profileUsecase: ProfileUsecase) {
        self.profileUsecase = profileUsecase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let cellDidTap: Observable<IndexPath>
        let editImageButtonTap: Observable<Void>
    }
    
    struct Output {
        var nickName: String?
        var imageData: Data?
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.profileUsecase.getUserInfo()
            })
            .disposed(by: disposeBag)
        
        self.profileUsecase.nickName
            .subscribe(onNext: { str in
                output.nickName = str
            })
            .disposed(by: disposeBag)
        
        self.profileUsecase.imageData
            .subscribe(onNext: { image in
                output.imageData = image
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func logout() {
        self.profileUsecase.logout()
    }
    
    func changeImage(image: Data){
        self.profileUsecase.changeImage(image: image)
    }
    
    func changeNickName(nickName: String) {
        self.profileUsecase.changeNickName(nickName: nickName)
    }
    
}
