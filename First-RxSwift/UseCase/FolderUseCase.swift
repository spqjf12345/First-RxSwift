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
    
    var filteredFolders = PublishSubject<[SectionOfFolder]>()
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
                self.filteredFolders.onNext([SectionOfFolder(items: folder)])
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
        if idx == 0 {
            let item = folder[0].items.sorted { $0.folderName.localizedStandardCompare($1.folderName) == .orderedAscending }
            self.filteredFolders.onNext([SectionOfFolder(items: item)])
        }else if idx == 1 {
            let item = folder[0].items.sorted { $0.folderId < $1.folderId }
            self.filteredFolders.onNext([SectionOfFolder(items: item)])
        }
        else if idx == 2 {
            let item = folder[0].items.sorted { $0.folderId > $1.folderId }
            self.filteredFolders.onNext([SectionOfFolder(items: item)])
        }
    }
    
    func filteredFolder(base folder: [SectionOfFolder], from text: String) {
        //return folders.map { $0[0].items.map { $0.folderName.hasPrefix(text) == true }}
        print("first folder \(folder[0].items.map { $0.folderName })")
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
        let folder = folder[0].items.filter { $0.folderName.hasPrefix(text) }
        if folder.isEmpty {
            print("is empty")
            filteredFolders = self.folders
        }else {
            print("is nn")
            filteredFolders.onNext([SectionOfFolder(items: folder)])
        }
        
        print("get folder \(folder)")
     
    }
    
        
    

    
    
    
}

