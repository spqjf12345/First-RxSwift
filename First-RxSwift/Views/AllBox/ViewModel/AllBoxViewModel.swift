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
    
    private let folderUseCase: FolderUseCase!
    
    let disposeBag = DisposeBag()
    var folders = PublishSubject<[SectionOfFolder]>()
    var filteredFolders = PublishSubject<[SectionOfFolder]>()
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
        let chageFolderNameTap: Observable<Void>
        let changeFolderImageTap: Observable<Void>
        let deleteFolder: Observable<Void>
        let sortingButtonTap: Observable<Void>
    }
  
    struct Output {
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
                    .subscribe(onNext: { folder in
                        print("get folder \(folder)")
                        self.folders.onNext(folder)
                        self.folderCount = folder[0].items.count
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
        
        input.searchTextField
            .debounce(.microseconds(5), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.folderUseCase.filteredFolder(base: self.folders, from: text)
                    .subscribe(onNext: { [weak self] filter in
                        guard let self = self else { return }
                        self.filteredFolders.onNext(filter)
                    }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
            
        
        input.folderCellTap
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                self.folders.subscribe(onNext: { folder in
                    for f in folder {
                        let folderId = f.items[indexPath.row].folderId
                        let folderType = f.items[indexPath.row].type
                        
                        if folderType == "PHRASE" {
                            //self.steps.accept(AllStep.textIn(folderId: folderId))
                        }else if folderType == "LINK" {
                            //self.steps.accept(AllStep.linkIn(folderId: folderId))
                        }
                    }
                   
                    
    //                self.folderUseCase.viewFolder(folderId: folderId)
    //                    .subscribe(onNext: { selected in
    //                        self.selectedFolder = selected
    //
    //
    //                    }).disposed(by: disposeBag)
                }).disposed(by: disposeBag)
            }).disposed(by: disposeBag)
               
        
        return output
       
    }
    
    func sortBy(_ index: Int){
//        switch index {
//        case 0:
//            let observable = folders.map { folder in
//                return folder[0].items.sorted {  $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
//            }
//            
//            observable.subscribe(onNext: { [weak self] folder in
//                guard let self = self else { return }
//                self.folders.onNext([SectionOfFolder(items: folder)])
//            }).disposed(by: disposeBag)
//            break
//        case 1:
//            folders.map { folder in
//                return folder[0].items.sorted { $0.folderId < $1.folderId }
//            }.subscribe(onNext: { [weak self] folder in
//                guard let self = self else { return }
//                self.folders.onNext([SectionOfFolder(items: folder)])
//            }).disposed(by: disposeBag)
//            break
//        case 2:
//            folders.map { folder in
//                return folder[0].items.sorted { $0.folderId > $1.folderId }
//            }.subscribe(onNext: { [weak self] folder in
//                guard let self = self else { return }
//                self.folders.onNext([SectionOfFolder(items: folder)])
//            }).disposed(by: disposeBag)
//            break
//        default:
//            break
//        }

    }
    
    func findFolderId(_ index: Int) -> Int {
        var folderId: Int = 0
        self.folders.subscribe(onNext: { folder in
            print("findFolderId \(folder)")
            folderId = folder[0].items[index].folderId
        }).disposed(by: disposeBag)
        return folderId
    }
    
    
    
}


