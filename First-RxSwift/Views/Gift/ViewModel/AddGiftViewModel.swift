//
//  AddGiftViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/08.
//

import Foundation
import RxSwift
import RxCocoa

class AddGiftViewModel {
    private let giftUsecase: GiftUseCaseType
    
    let disposeBag = DisposeBag()
    let defaultImageView = UIImage(systemName: "questionmark.square")
    let imageView = PublishRelay<UIImage?>()
    let userId = UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    
    init(giftUsecase: GiftUseCase){
        self.giftUsecase = giftUsecase
    }
    
    struct Input {
        let touchImage: Observable<UITapGestureRecognizer>
        let deleteButtonTap: Observable<Void>
        let giftNameTextField: Observable<String>
        let giftDueDatePicker: Observable<String> // datepicker
        let weekButtonTap: Observable<Void>
        let threeButtonTap: Observable<Void>
        let oneButtonTap: Observable<Void>
        let storeButtonTap: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let setAlarmDate = PublishRelay<[Int]>()
        let disMiss = PublishRelay<Void>()
        let enableDoneButton = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        imageView.accept(defaultImageView)
        
        input.storeButtonTap
            .withLatestFrom(Observable.combineLatest(imageView, input.giftNameTextField, output.setAlarmDate, input.giftDueDatePicker))
            .bind { (image, name, alarm, dueDate) in
                if(image == self.defaultImageView){
                    output.errorMessage.accept("이미지를 선택해주세요")
                    output.enableDoneButton.accept(false)
                }else if(name.isEmpty) {
                    output.errorMessage.accept("폴더 이름을 입력해주세요")
                }else if(name.count > 10) {
                    output.errorMessage.accept("폴더 이름을 15글자 이내로 입력해주세요")
                    output.enableDoneButton.accept(false)
                }else if (alarm.isEmpty){
                    output.errorMessage.accept("알림을 한개 이상 선택해 주세요")
                    output.enableDoneButton.accept(false)
                }else {
                    print("here")
                    self.giftUsecase.createGifticon(gift: CreateGift(userId: self.userId, title: name, deadline: dueDate, isValid: true, selected: alarm, imageFile: image!.pngData()!))
                    output.enableDoneButton.accept(true)
                }
            }
            .disposed(by: disposeBag)

        return output
    }
}
