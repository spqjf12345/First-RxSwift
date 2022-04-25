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
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse>
    func changeName(folderId: Int, changeName: String)
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
    
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse> {
        return folderService.viewFolder(folderId: folderId)
    }
    
    func changeName(folderId: Int, changeName: String) {
        folderService.changeName(folderId: folderId, changeName: changeName)
            .catchAndReturn("error").subscribe(onNext: { str in
            print(str)
            }, onError: { error in print("err \(error)")}).disposed(by: disposeBag)
    }
    
    func changeImage(folderId: Int, imageData: Data) {
        folderService.changeImage(folderId: folderId, imageData: imageData)
            .catchAndReturn("error").subscribe(onNext: { str in
            print("changeImage \(str)")
            }, onError: { error in print("err \(error)")}).disposed(by: disposeBag)
    }
    
    func deleteFolder(folderId: Int) {
        folderService.deleteFolder(folderId: folderId).subscribe(onNext: { str in
            print(str)
        }).disposed(by: disposeBag)
    }
    
    func createFolder(folder: CreateFolderRequest) {
        folderService.createFolder(folder: folder).subscribe(onNext: { str in
            print(str)
        }).disposed(by: disposeBag)
    }
    
}
