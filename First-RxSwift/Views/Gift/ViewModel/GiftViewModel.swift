//
//  GiftViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import RxSwift
import RxCocoa
import RxGesture

class GiftViewModel {
    var giftUsecase: GiftUseCase!
    var count = 0
    var gift: [SectionOfGift] = []
    init(giftUsecase: GiftUseCase) {
        self.giftUsecase = giftUsecase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let refreshEvent: Observable<Void>
        let searchTextField: Observable<String>
        let floatingButtonTap: Observable<Void>
        let giftCellTap: Observable<IndexPath> // giftId
        let folderMoreButtonTap:Observable<Int>
//        let sortingButtonTap: Observable<Void>
//        let deleteTap: ControlEvent<UILongPressGestureRecognizer>
    }
    
    struct Output {
        var selectedGift = PublishSubject<SelectedFolderType>()
        var sortingTap = PublishRelay<Bool>()
        var didFilderedGift = PublishSubject<Bool>()
        let reloadData = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        ///get folders
        Observable.of(input.viewWillAppearEvent, input.refreshEvent)
            .merge()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
               self.giftUsecase.getGifticon()
            }).disposed(by: disposeBag)
        
        ///usecase binding
        self.giftUsecase.count
            .subscribe(onNext: { cnt in
                self.count = cnt
            }).disposed(by: disposeBag)
        
        self.giftUsecase.gifticon
            .subscribe(onNext: { gift in
                self.gift = gift
            }).disposed(by: disposeBag)
        
        input.searchTextField
            .debounce(.microseconds(10), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.giftUsecase.filteredFolder(base: self.gift, from: text)
                output.didFilderedGift.onNext(true)
            }).disposed(by: disposeBag)
        
        return output
    }
    
    func deleteGifticon(giftId: Int){
        self.giftUsecase.deleteGifticon(giftId: giftId)
    }
    
    func checkIsValid(index: Int) -> Bool {
        return gift[0].items[index].isValid
    }
    
    func findGiftId(index: Int) -> Int {
        return self.gift[0].items[index].timeoutId
    }
    
    func getSelectedGift(index: Int) -> Gift {
//        let giftId = findGiftId(index: index)
        return self.gift[0].items[index]
    }
    
    func getGiftSelected(giftId: Int) -> [Int] {
        return self.gift[0].items.filter { $0.timeoutId == giftId }[0].selected
    }
    
    func sortBy(_ index: Int){
        giftUsecase.updateGift(gift: self.gift, idx: index)
    }
    
    func deleteNotification(giftId: Int) {
        let notiManager = LocalNotificationManager()
        let notiidentifier = "t_\(giftId)_"
        let selectedArray: [Int] = self.getGiftSelected(giftId: giftId)
        
        DispatchQueue.global().async {
            notiManager.deleteSchedule(notificationId: notiidentifier + "0")
            for i in selectedArray {
                notiManager.deleteSchedule(notificationId: notiidentifier +
                   "\(i)")
            }
        }
        
    }

    
    
}
