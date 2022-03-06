//
//  AllBoxViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI

class AllBoxViewModel {

    private let folderUseCase: FolderUseCase
    
    let disposeBag = DisposeBag()
    
    init(folderUseCase: FolderUseCase){
        self.folderUseCase = folderUseCase
//        getFolders()
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let refreshEvent: Observable<Void>
        let searchTextField: Observable<Void>
        let floatingButtonTap: Observable<Void>
        let folderCellTap: Observable<Int> // folderId
        let folderMoreButtonTap:Observable<Int>
        let chageFolderNameTap: Observable<Void>
        let changeFolderImageTap: Observable<Void>
        let deleteFolder: Observable<Void>
        let sortingButtonTap: Observable<Void>
    }
  
    struct Output {
        var folderCount = PublishRelay<String>() //개의 폴더
        var sortingText = BehaviorRelay<String>(value: "이름 순") //이름순, 생성순, 최신순
        var folders = BehaviorSubject<[Folder]>(value: [])
        var selectedFolders = Folder.Empty
        var filteredFolders = BehaviorSubject<[Folder]>(value: [])
    }
    
//    func getFolders(){
//        //getfolder
//
//    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
    
        ///get folders
        Observable.of(input.viewWillAppearEvent, input.refreshEvent)
            .merge()
            .subscribe(onNext: { [weak self] in
                self?.folderUseCase.getFolders()
            }).disposed(by: disposeBag)
        
        self.folderUseCase.folderCount
            .map { "\($0)개의 폴더"}
            .bind(to: output.folderCount)
            .disposed(by: disposeBag)
        
        return output
       
    }
    
    
    
}
