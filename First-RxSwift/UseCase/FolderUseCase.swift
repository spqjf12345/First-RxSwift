//
//  FolderUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import RxSwift

protocol FolderUseCateType {
    func getFolders() -> Observable<[SectionOfFolder]>
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse>
}

class FolderUseCase: FolderUseCateType {
    
    
    private let folderRepository: FolderRepository
    
    var disposeBag = DisposeBag()
    
    init(repository: FolderRepository) {
        self.folderRepository = repository
    }
    
    func getFolders() -> Observable<[SectionOfFolder]> {
        let observable = Observable<[SectionOfFolder]>.create { observer in
            self.folderRepository.getFolders()
                .subscribe(onNext: { folder in
                    observer.onNext([SectionOfFolder(items: folder)])
                })
        }
        return observable
        
    }
    
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse> {
        return self.folderRepository.viewFolder(folderId: folderId)
    }
    
    func filteredFolder(base folder: PublishSubject<[SectionOfFolder]>, from text: String) -> Observable<[SectionOfFolder]> {
        var filteredFolder = SectionOfFolder.EMPTY
        folder.subscribe(onNext: { folder in
            for f in folder {
                f.items.forEach {
                    if $0.folderName.hasPrefix(text) {
                        filteredFolder.items.append($0)
                    }
                }
            }
        }).disposed(by: disposeBag)
        return Observable.of([filteredFolder])
    }
    
        
    

    
    
    
}

