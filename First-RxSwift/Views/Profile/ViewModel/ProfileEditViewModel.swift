//
//  ProfileEditViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/16.
//

import Foundation
import RxSwift
import RxCocoa

class ProfileEditViewModel {
    private let profileUsecase: ProfileUsecase
    
    let disposeBag = DisposeBag()
    
    init(profileUsecase: ProfileUsecase) {
        self.profileUsecase = profileUsecase
    }
    
    struct Input {
        var editButtonTap: Observable<Void>
        
    }
    
    struct Output {
       
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        
        return output
    }
}
