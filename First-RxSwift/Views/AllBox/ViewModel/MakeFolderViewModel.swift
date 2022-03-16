//
//  MakeFolderViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/17.
//

import Foundation
import RxSwift
import RxCocoa

class MakeFolderViewModel {
    
    private let folderUseCase: FolderUseCase!
    
    let disposeBag = DisposeBag()
    init(folderUseCase: FolderUseCase){
        self.folderUseCase = folderUseCase
    }
    
    struct Input {
        let touchImage: Observable<Void>
        let deleteButtonTap: Observable<Void>
        let folderNameTextField: Observable<String>
        let foderType: Observable<String>
        let storeButtonTap: Observable<Void> // 저장
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let disMiss = PublishRelay<Void>()
    }
    
    
}
