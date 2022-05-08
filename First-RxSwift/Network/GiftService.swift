//
//  GiftService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import Moya
import RxSwift

class GiftService {
    let provider = MoyaProvider<GiftAPI>()
    var userId: Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    }
    
    func getGifts() -> Observable<[Gift]> {
        return self.provider.rx.request(.getGift(userId: userId))
            .filterSuccessfulStatusCodes()
            .map([Gift].self)
            .asObservable()
    }
    
    func createGifts(gifts: CreateGift) -> Observable<String> {
        return self.provider.rx.request(.createGift(userId: userId, gift: gifts))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
    
    func updateGifts(giftId: Int, image: Data, gifts: UpdateGift) -> Observable<String> {
        
        let dataObservable = self.provider.rx.request(.updateGiftData(userId: userId, giftId: giftId, gift: gifts))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
        
        let imageObservable = self.provider.rx.request(.updateGiftImage(userId: userId, giftId: giftId, image: image))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
        
        return Observable.of(dataObservable, imageObservable).merge()
    }
    
    func deleteGifts(giftId: Int) -> Observable<String> {
        return self.provider.rx.request(.deleteGift(userId: userId, giftId: giftId))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
    
    func usedGifts(giftId: Int) -> Observable<String> {
        return self.provider.rx.request(.usedGift(userId: userId, giftId: giftId))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
}
