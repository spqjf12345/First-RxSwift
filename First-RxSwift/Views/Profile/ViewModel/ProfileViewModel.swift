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
    private let profileUsecase: ProfileUsecase
    
    let disposeBag = DisposeBag()
    
    init(profileUsecase: ProfileUsecase) {
        self.profileUsecase = profileUsecase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let cellDidTap: Observable<Void>
        let editImageButtonTap: Observable<Void>
    }
    
    struct Output {
        var nickname: String
        var imageData =  PublishSubject<Data>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output(
            nickname: self.profileUsecase.nickName ?? "알 수 없는 사용자"
        )
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.profileUsecase.getUserInfo()
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func logout() {
        self.profileUsecase.
    }
    
}
