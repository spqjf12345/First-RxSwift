//
//  FolderAPI.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation
import Moya

enum FolderAPI {
    case getFolders(userId: Int)
    case viewFolder(userId:Int, folderId: Int)
    
}

extension FolderAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .getFolders(let userId):
            return "/users/\(userId)/folders"
        case .viewFolder(let userId,let folderId):
            return "/users/\(userId)/folders/\(folderId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFolders:
            return .get
        case .viewFolder:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getFolders:
            return .requestPlain
        case .viewFolder:
            return .requestPlain
        }
    }
    
        
    var headers: [String : String]? {
        let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken)!
        return ["Authorization": jwtToken]
    }
    

}
