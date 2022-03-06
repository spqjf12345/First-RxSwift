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
}

class FolderUseCase: FolderUseCateType {
    
    private let folderRepository: FolderRepository
    
    var folders = PublishSubject<[Folder]>()
    lazy var folderCount = folders.map { $0.count }
    
    var disposeBag = DisposeBag()
    
    init(repository: FolderRepository) {
        self.folderRepository = repository
    }
    
    func getFolders() {
        self.folderRepository.getFolders()
            .subscribe(onNext: { [weak self] folders in
                self?.folders.onNext(folders)
            }).disposed(by: disposeBag)
    }
    
    
}

