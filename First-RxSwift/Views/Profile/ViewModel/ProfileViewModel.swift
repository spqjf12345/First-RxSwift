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
        let cellDidTap: Observable<Int>
        let editImageButtonTap: Observable<Void>
    }
    
    struct Output {
        var nickName: String?
        var imageData =  PublishSubject<Data>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.profileUsecase.getUserInfo()
            })
            .disposed(by: disposeBag)
        
        self?.profileUsecase.nickName
            .subscribe(onNext: { str in
                output.nickName = str
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func logout() {
        self.profileUsecase.logout()
    }
    
   // func update
    
}
