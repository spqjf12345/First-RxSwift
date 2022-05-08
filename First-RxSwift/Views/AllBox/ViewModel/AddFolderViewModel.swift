//
//  MakeFolderViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/17.
//

import Foundation
import RxSwift
import RxCocoa

class AddFolderViewModel {
    
    private let folderUseCase: FolderUseCase!
    
    let disposeBag = DisposeBag()
    var parentFolderId: Int = 0
    let imageView: Observable<UIImage?>
    let userId = UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    init(folderUseCase: FolderUseCase){
        self.folderUseCase = folderUseCase
        self.imageView = Observable.just(UIImage(systemName: "questionmark.square"))
    }
    
    struct Input {
        let touchImage: Observable<UITapGestureRecognizer>
        let deleteButtonTap: Observable<Void>
        let folderNameTextField: Observable<String>
        let foderTypeButtonTap: Observable<Void>
        let storeButtonTap: Observable<Void>
    }
    
    struct Output {
        let errorMessage = PublishRelay<String>()
        let folderType = PublishRelay<String>()
        let disMiss = PublishRelay<Void>()
        let enableDoneButton = PublishRelay<Bool>()
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        input.storeButtonTap
            .withLatestFrom(Observable.combineLatest( imageView, input.folderNameTextField, output.folderType))
            .bind { (image, name, type) in
                print("storeButtonTap \(type)")
                if(image == nil){
                    output.errorMessage.accept("이미지를 선택해주세요")
                    output.enableDoneButton.accept(false)
                }else if(name.isEmpty) {
                    output.errorMessage.accept("폴더 이름을 입력해주세요")
                }else if(name.count > 10) {
                    output.errorMessage.accept("폴더 이름을 10글자 이내로 입력해주세요")
                    output.enableDoneButton.accept(false)
                }else if (type != "PHRASE" || type != "LINK"){
                    output.errorMessage.accept("폴더 타입을 선택해주세요")
                    output.enableDoneButton.accept(false)
                }else {
                    self.folderUseCase.createFolder(folder: CreateFolderRequest(folderName: name, userId: self.userId, type: type, parentFolderId: 0, imageFile: (image?.pngData())!))
                    output.enableDoneButton.accept(true)
                }
            }
        
            
            .disposed(by: disposeBag)
        return output
    }
    
    
}
