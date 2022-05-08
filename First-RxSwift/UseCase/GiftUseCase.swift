//
//  GiftUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import RxSwift

protocol GiftUseCaseType {
    func getGifticon()
    func updateGifticon(giftId: Int, image: Data, gift: UpdateGift)
    func deleteGifticon(giftId: Int)
    func createGifticon(gift: CreateGift)
    func usedGifticon(giftId: Int)
}

class GiftUseCase: GiftUseCaseType {
    
    private let giftRepository: GiftRepositoryType
    var count = PublishSubject<Int>()
    var gifticon = BehaviorSubject<[SectionOfGift]>(value: [])
    var originalGifticon = [SectionOfGift]()
    var disposeBag = DisposeBag()
    
    init(repository: GiftReposotory) {
        self.giftRepository = repository
    }
    
    func getGifticon() {
        print("usecase getGifticon")
        giftRepository.getGifticon()
            .subscribe(onNext: { [weak self] gifts in
                guard !gifts.isEmpty else {
                    guard let self = self else { return }
                    self.count.onNext(0)
                    return
                }
                print(gifts)
                self?.gifticon.onNext([SectionOfGift(items: gifts)])
                self?.originalGifticon = [SectionOfGift(items: gifts)]
                self?.count.onNext(gifts.count)
                
            }).disposed(by: disposeBag)
    }
    
    func updateGifticon(giftId: Int, image: Data, gift: UpdateGift) {
        giftRepository.updateGifticon(gifdId: giftId, image: image, gift: gift)
    }
    
    func deleteGifticon(giftId: Int) {
        giftRepository.deleteGifticon(giftId: giftId)
    }
    
    func createGifticon(gift: CreateGift) {
        giftRepository.createGift(gift: gift)
    }
    
    func usedGifticon(giftId: Int) {
        giftRepository.usedGofticon(giftId: giftId)
    }
    
    func filteredFolder(base gift: [SectionOfGift], from text: String) {
        let gift = gift[0].items.filter { $0.title.hasPrefix(text) }
        if gift.isEmpty {
            self.gifticon.onNext(originalGifticon)
        }else {
            self.gifticon.onNext([SectionOfGift(items: gift)])
        }
    }
    
    func updateGift(gift: [SectionOfGift], idx: Int) {
        if idx == 0 {
            let item = gift[0].items.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
            self.gifticon.onNext([SectionOfGift(items: item)])
        }else if idx == 1 {
            let item = gift[0].items.sorted { $0.timeoutId < $1.timeoutId }
            self.gifticon.onNext([SectionOfGift(items: item)])
        }else if idx == 2 {
            let item = gift[0].items.sorted { $0.timeoutId > $1.timeoutId }
            self.gifticon.onNext([SectionOfGift(items: item)])
        }
    }
}
