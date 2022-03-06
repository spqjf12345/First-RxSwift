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
    let userId: Int
    init(userId: Int){
        self.userId = UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
    }
    
    func getFolders() -> Observable<[Folder]> {
        self.provider.rx.request(.getFolders(userId: userId))
            .filterSuccessfulStatusCodes()
            .map([Folder].self)
            .asObservable()
    }
    
}
