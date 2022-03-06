//
//  FolderRepository.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import Moya
import RxSwift

protocol FolderRepositoryType {
    func getFolders() -> Observable<[Folder]>
}

class FolderRepository: FolderRepositoryType {
    
    let folderService: FolderService
    let disposeBag = DisposeBag()
    
    init(folderService: FolderService){
        self.folderService = folderService
    }
    
    func getFolders() -> Observable<[Folder]> {
        return folderService.getFolders()
    }
    
}
