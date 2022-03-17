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
    
    func filteredFolder(base folder: [SectionOfFolder], from text: String) -> Observable<[SectionOfFolder]>  {
        
        //return folders.map { $0[0].items.map { $0.folderName.hasPrefix(text) == true }}
        
        var filteredFolder = SectionOfFolder.EMPTY
        folders.subscribe(onNext: { folder in
            let folder = folder[0].items

            folder.forEach {
                    if $0.folderName.hasPrefix(text) {
                        filteredFolder.items.append($0)
                    }
                }

        }).disposed(by: disposeBag)
        return Observable.of([filteredFolder])
    }
    
        
    

    
    
    
}

