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
    
    let folderUseCase: FolderUseCase!
    
    let disposeBag = DisposeBag()
    var folders = [SectionOfFolder]()
    var filteredFolders = [SectionOfFolder]()
    var selectedFolder: ViewFolderResponse!
    var folderCount : Int = 0
    
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
        let sortingButtonTap: Observable<Void>
    }
  
    struct Output {
        var sortingText = BehaviorRelay<String>(value: "이름 순") //이름순, 생성순, 최신순
        let reloadData = PublishRelay<Bool>()
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
        
        input.searchTextField
            .debounce(.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.folderUseCase.filteredFolder(base: self.folders, from: text)
                    .subscribe(onNext: { [weak self] filter in
                        guard let self = self else { return }
                        self.filteredFolders = filter
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
            
        
        input.folderCellTap
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let folderId = self.folders[0].items[indexPath.row].folderId
                let folderType = self.folders[0].items[indexPath.row].type
                if folderType == "PHRASE" {
                    //self.steps.accept(AllStep.textIn(folderId: folderId))
                }else if folderType == "LINK" {
                    //self.steps.accept(AllStep.linkIn(folderId: folderId))
                }
                   
                    
    //                self.folderUseCase.viewFolder(folderId: folderId)
    //                    .subscribe(onNext: { selected in
    //                        self.selectedFolder = selected
    //
    //
    //                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
               
        ///binding usecase
        folderUseCase.folders.subscribe(onNext: { [weak self] folder in
            guard let self = self else { return }
            self.folders = folder
            print("allFolders \(self.folders)")
            self.folderCount = folder[0].items.count
        }).disposed(by: disposeBag)
        
        return output
       
    }
    
    func sortBy(_ index: Int){
        switch index {
        case 0:
            folders[0].items = self.folders[0].items.sorted { $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
        case 1:
            folders[0].items = self.folders[0].items.sorted {  $0.folderId < $1.folderId }
        case 2:
            folders[0].items = self.folders[0].items.sorted { $0.folderId > $1.folderId }
        default:
            break
        }
        print("changed \(folders[0].items)")
    }
    
    func findFolderId(_ index: Int) -> Int {
        return self.folders[0].items[index].folderId
    }
    
    func changeFolderName(folderId: Int, changeName: String) {
        self.folderUseCase.changeName(folderId: folderId, changeName: changeName)
    }
    
    func changeFolderImage(folderId: Int, imageData: Data) {
        self.folderUseCase.changeImage(folderId: folderId, imageData: imageData)
    }
    
    
    
}


