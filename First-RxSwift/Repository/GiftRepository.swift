//
//  GiftRepository.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import RxSwift

protocol GiftRepositoryType {
    func getGifticon() -> Observable<[Gift]>
    func updateGifticon(gifdId: Int, image: Data, gift: UpdateGift)
    func deleteGifticon(giftId: Int)
    func createGift(gift: CreateGift)
    func usedGofticon(giftId: Int)
}

class GiftReposotory: GiftRepositoryType {
    
    let giftService: GiftService
    
    let disposeBag = DisposeBag()
    
    init(giftService: GiftService){
        self.giftService = giftService
    }
    func getGifticon() -> Observable<[Gift]> {
        return giftService.getGifts()
    }
    
    func updateGifticon(gifdId: Int, image: Data, gift: UpdateGift) {
        self.giftService.updateGifts(giftId: gifdId, image: image, gift: gift)
            .catchAndReturn("error").subscribe { string in print(string) }.disposed(by: disposeBag)
    }
    
    func deleteGifticon(giftId: Int) {
        self.giftService.deleteGifts(giftId: giftId)
            .catchAndReturn("error").subscribe { string in print(string) }.disposed(by: disposeBag)
    }
    
    func createGift(gift: CreateGift) {
        self.giftService.createGifts(gift: gift).catchAndReturn("error").subscribe { string in print(string) }.disposed(by: disposeBag)
    }
    
    func usedGofticon(giftId: Int) {
        self.giftService.usedGifts(giftId: giftId).catchAndReturn("error").subscribe { string in print(string) }.disposed(by: disposeBag)
    }
    
    
}
