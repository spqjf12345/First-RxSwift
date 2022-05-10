//
//  UserProfileService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/09.
//

import Foundation
import Moya
import RxSwift

class UserProfileService {
    let provider = MoyaProvider<ProfileAPI>()
    let disposeBag = DisposeBag()
    
    var userId: Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    }
    
    func getUserInfo() -> Observable<ProfileResponse> {
        self.provider.rx.request(.getUserInfo(userId: userId))
            .filterSuccessfulStatusCodes()
            .map(ProfileResponse.self)
            .asObservable()
    }
    
    
}
