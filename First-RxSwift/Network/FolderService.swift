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
            .map(ViewFolderResponse)
            .asObservable()
                                
    }
    
}
