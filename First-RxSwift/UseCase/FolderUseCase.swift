//
//  FolderUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import RxSwift

protocol FolderUseCateType {
    func getFolders()
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse>
    func changeName(folderId: Int, changeName: String)
    func changeImage(folderId: Int, imageData: Data)
    func deleteFolder(folderId: Int)
    func createFolder(folder: CreateFolderRequest)
}

class FolderUseCase: FolderUseCateType {
    
    var folders = PublishSubject<[SectionOfFolder]>()
    
    private let folderRepository: FolderRepository
    
    var disposeBag = DisposeBag()
    
    init(repository: FolderRepository) {
        self.folderRepository = repository
    }
    
    func getFolders() {
        self.folderRepository.getFolders()
            .subscribe(onNext: { [weak self] folder in
                guard let self = self else { return }
                self.folders.onNext([SectionOfFolder(items: folder)])
            }).disposed(by: self.disposeBag)
    }
    
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse> {
        return self.folderRepository.viewFolder(folderId: folderId)
    }
    
    func changeName(folderId: Int, changeName: String) {
        self.folderRepository.changeName(folderId: folderId, changeName: changeName)
    }
    
    func changeImage(folderId: Int, imageData: Data) {
        self.folderRepository.changeImage(folderId: folderId, imageData: imageData)
    }
    
    func deleteFolder(folderId: Int) {
        self.folderRepository.deleteFolder(folderId: folderId)
    }
    
    func createFolder(folder: CreateFolderRequest){
        self.folderRepository.createFolder(folder: folder)
    }
    
    func updateFolder(folder: [SectionOfFolder], idx: Int ) {
        print("update folder \(idx)")
        //        case 0:
        //            folders[0].items = self.folders[0].items.sorted { $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
        //        case 1:
        //            folders[0].items = self.folders[0].items.sorted {  $0.folderId < $1.folderId }
        //        case 2:
        //            folders[0].items = self.folders[0].items.sorted { $0.folderId > $1.folderId }
        if idx == 0 {
            let item = folder[0].items.sorted { $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
            self.folders.onNext([SectionOfFolder(items: item)])
            
//            self.folders.map ({ (item) -> [Folder] in
//                return item[0].items.sorted { $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
//            }).subscribe(onNext: { [weak self] item in
//                guard let self = self else { return }
//                print("idx 0 \(item)")
//                self.folders.onNext([SectionOfFolder(items: item)])
//            }).disposed(by: disposeBag)
        }else if idx == 1 {
//            self.folders.map ({ (item) -> [Folder] in
//                return item[0].items.sorted { $0.folderId < $1.folderId }
//            }).subscribe(onNext: { [weak self] item in
//                guard let self = self else { return }
//                print("idx 1 \(item)")
//                self.folders.onNext([SectionOfFolder(items: item)])
//            }).disposed(by: disposeBag)
            let item = folder[0].items.sorted { $0.folderId < $1.folderId }
            self.folders.onNext([SectionOfFolder(items: item)])
        }
        else if idx == 2 {
//            self.folders.map ({ (item) -> [Folder] in
//                let sorted = item[0].items.sorted { $0.folderId > $1.folderId }
//                print(sorted)
//                return sorted
//            }).subscribe(onNext: { [weak self] item in
//                guard let self = self else { return }
//                print("idx 2 \(item)")
//                self.folders.onNext([SectionOfFolder(items: item)])
//            }).disposed(by: disposeBag)
            let item = folder[0].items.sorted { $0.folderId > $1.folderId }
            self.folders.onNext([SectionOfFolder(items: item)])
        }
        
        
        
    }
    
//    func filteredFolder(base folder: [SectionOfFolder], from text: String) -> Observable<[SectionOfFolder]>  {
//
//        //return folders.map { $0[0].items.map { $0.folderName.hasPrefix(text) == true }}
//
//        var filteredFolder = SectionOfFolder.EMPTY
//        folders.subscribe(onNext: { folder in
//            let folder = folder[0].items
//
//            folder.forEach {
//                    if $0.folderName.hasPrefix(text) {
//                        filteredFolder.items.append($0)
//                    }
//                }
//
//        }).disposed(by: disposeBag)
//        return Observable.of([filteredFolder])
//    }
    
        
    

    
    
    
}

