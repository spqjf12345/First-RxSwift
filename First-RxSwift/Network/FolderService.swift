//
//  FolderService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import Moya
import RxSwift

class FolderService {
    let provider = MoyaProvider<FolderAPI>()
    var userId: Int {
        return UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    }
    
    func getFolders() -> Observable<[Folder]> {
        self.provider.rx.request(.getFolders(userId: userId))
            .filterSuccessfulStatusCodes()
            .map([Folder].self)
            .asObservable()
    }
    
    func viewFolder(folderId: Int) -> Observable<ViewFolderResponse> {
        self.provider.rx.request(.viewFolder(userId: userId, folderId: folderId))
            .filterSuccessfulStatusCodes()
            .map(ViewFolderResponse.self)
            .asObservable()
                                
    }
    
    func changeName(folderId: Int, changeName: String) -> Observable<String> {
        self.provider.rx.request(.changeFolderName(userId: userId, folderId: folderId, changeName: changeName))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()

    }
    
    func changeImage(folderId: Int, imageData: Data) -> Observable<String> {
        self.provider.rx.request(.changeFolderImage(userId: userId, folderId: folderId, imageData: imageData))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
    
    func deleteFolder(folderId: Int) -> Observable<String> {
        self.provider.rx.request(.deleteFolder(userId: userId, folderId: folderId))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
    
    func createFolder(folder: CreateFolderRequest) -> Observable<String> {
        self.provider.rx.request(.createFolder(userId: userId, folderRequest: folder))
            .filterSuccessfulStatusCodes()
            .mapString()
            .asObservable()
    }
    
}
