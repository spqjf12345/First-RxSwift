//
//  FolderUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import RxSwift

protocol FolderUseCateType {
    func getFolders() -> Observable<[Folder]>
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse>
}

class FolderUseCase: FolderUseCateType {
    
    
    private let folderRepository: FolderRepository
    
    var disposeBag = DisposeBag()
    
    init(repository: FolderRepository) {
        self.folderRepository = repository
    }
    
    func getFolders() -> Observable<[Folder]> {
        return self.folderRepository.getFolders()
    }
    
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse> {
        return self.folderRepository.viewFolder(folderId: folderId)
    }
    
    func filteredFolder(base folder: BehaviorSubject<[Folder]>, from text: String) -> Observable<[Folder]> {
        var filteredFolder: [Folder] = []
        folder.subscribe(onNext: { folder in
            folder.forEach {
                if $0.folderName.hasPrefix(text) {
                    filteredFolder.append($0)
                }
            }
        }).disposed(by: disposeBag)
        return Observable.of(filteredFolder)
    }
    
        
    

    
    
    
}

