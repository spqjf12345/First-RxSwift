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
    func viewFolder()
}

class FolderUseCase: FolderUseCateType {
    
    private let folderRepository: FolderRepository
    
    var folders = BehaviorSubject<[Folder]>(value: [])
    var filderedFolders = BehaviorSubject<[Folder]>(value: [])
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
    
    func viewFolder(){
        self.folderRepository.viewFolder()
    }
    
    func filteredFolder(base folder: [Folder], from text: String) {
        self.filterText(folder, text)
            .subscribe { [weak self] folder in
                self?.folders.onNext(folder)
            }
            .disposed(by: self.disposeBag)
    }
    
    func filterText(_ folder: [Folder], _ text: String) -> Observable<[Folder]> {
        var filteredFolder: [Folder] = []
        folder.forEach {
            if $0.folderName.hasPrefix(text) {
                filteredFolder.append($0)
            }
        }
        return Observable.of(filteredFolder)
    }
        
    

    
    
    
}

