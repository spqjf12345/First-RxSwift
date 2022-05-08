//
//  AddGiftViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import RxGesture

class AddGiftViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private var viewModel = GiftViewModel(giftUsecase: GiftUseCase(repository: GiftReposotory(giftService: GiftService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
