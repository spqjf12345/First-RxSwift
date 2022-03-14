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
import RxFlow

class AllBoxViewModel: Stepper {
    var steps = PublishRelay<Step>()
    
    private let folderUseCase: FolderUseCase
    
    let disposeBag = DisposeBag()
    var folders:[Folder] = []
    var filteredFolders:[Folder]?
    var selectedFolder: ViewFolderResponse!
    
    init(folderUseCase: FolderUseCase){
        self.folderUseCase = folderUseCase
    }
    
    struct Input {
        let viewWillAppearEvent: Observable<Void>
        let refreshEvent: Observable<Void>
        let searchTextField: Observable<String>
        let floatingButtonTap: Observable<Void>
        let folderCellTap: Observable<IndexPath> // folderId
        let folderMoreButtonTap:Observable<Int>
        let chageFolderNameTap: Observable<Void>
        let changeFolderImageTap: Observable<Void>
        let deleteFolder: Observable<Void>
        let sortingButtonTap: Observable<Void>
    }
  
    struct Output {
        var folderCount = PublishRelay<String>() //개의 폴더
        var sortingText = BehaviorRelay<String>(value: "이름 순") //이름순, 생성순, 최신순
    }
    
    func transform(from input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
    
        ///get folders
        Observable.of(input.viewWillAppearEvent, input.refreshEvent)
            .merge()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.folderUseCase.getFolders()
            }).disposed(by: disposeBag)
        
        //binding with folderUsecase
        self.folderUseCase.folders
            .subscribe(onNext: { folders in
                self.folders = folders
            }).disposed(by: disposeBag)
        
        
        self.folderUseCase.folderCount
            .map { "\($0)개의 폴더"}
            .bind(to: output.folderCount)
            .disposed(by: disposeBag)
        
        
        
        input.searchTextField
            .debounce(.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.folderUseCase.filteredFolder(base: self.folders ?? [], from: text)
            }).disposed(by: disposeBag)
            
         
        input.floatingButtonTap
            .subscribe(onNext: {
                self.steps.accept(AllStep.makeFolder)
            }).disposed(by: disposeBag)
        
        input.folderCellTap
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let folderId = self.folders[indexPath.row].folderId
                let folderType = self.folders[indexPath.row].type
                
                if folderType == "PHRASE" {
                    self.steps.accept(AllStep.textIn(folderId: folderId))
                }else if folderType == "LINK" {
                    self.steps.accept(AllStep.linkIn(folderId: folderId))
                }
                
//                self.folderUseCase.viewFolder(folderId: folderId)
//                    .subscribe(onNext: { selected in
//                        self.selectedFolder = selected
//
//
//                    }).disposed(by: disposeBag)
            })
        
        return output
       
    }
    
    
    
}


