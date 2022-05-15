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
    
    func changeImage(image: Data) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            return self.provider.rx.request(.changeUserImage(userId: self.userId, image: image))
                .filterSuccessfulStatusCodes()
                .mapString()
                .asObservable().subscribe(onNext: {str in
                    if str.isEmpty {
                        observer.onNext(false)
                    }else {
                        observer.onNext(true)
                    }
                })
                observer.onCompleted()
              return Disposables.create()
        }
            
    }
    
    func changeNickName(text: String) -> Observable<Bool> {
        return Observable<Bool>.create { observer -> Disposable in
            return self.provider.rx.request(.changeUserNickName(userId: self.userId, nickName: text))
                .filterSuccessfulStatusCodes()
                .mapString()
                .asObservable().subscribe(onNext: {str in
                    if str.isEmpty {
                        observer.onNext(false)
                    }else {
                        observer.onNext(true)
                    }
                })
                observer.onCompleted()
              return Disposables.create()
        }
    }
    
}
