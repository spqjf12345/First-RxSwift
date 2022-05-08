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
        let sortingButtonTap: Observable<Void>
        let deleteTap: ControlEvent<UILongPressGestureRecognizer>
    }
    
    struct Output {
        var selectedGift = PublishSubject<SelectedFolderType>()
        var sortingTap = PublishRelay<Bool>()
        var didFilderedFolder = PublishSubject<Bool>()
        let reloadData = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        var output = Output()
        ///get folders
        Observable.of(input.viewWillAppearEvent, input.refreshEvent)
            .merge()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
               self.giftUsecase.getGifticon()
            }).disposed(by: disposeBag)
        
        self.giftUsecase.count
            .subscribe(onNext: { cnt in
                self.count = cnt
            }).disposed(by: disposeBag)
        
        
    }
    
    func deleteGifticon(giftId: Int){
        self.giftUsecase.deleteGifticon(giftId: giftId)
    }
    
    func checkIsValid(index: IndexPath) -> Bool {
        return self.giftUsecase.isValidGifticon(index: index)
    }
    
    func sortBy(_ index: Int){
    
    }
    
    func findGiftId(){
        
    }
    
    
}
