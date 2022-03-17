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
    case changeFolderName(userId:Int, folderId: Int, changeName: String)
    
}

extension FolderAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .getFolders(let userId):
            return "/users/\(userId)/folders"
        case .viewFolder(let userId, let folderId):
            return "/users/\(userId)/folders/\(folderId)"
        case .changeFolderName(let userId, let folderId, _):
            return "/users/\(userId)/folders/\(folderId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFolders:
            return .get
        case .viewFolder:
            return .get
        case .changeFolderName:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
        case .getFolders:
            return .requestPlain
        case .viewFolder:
            return .requestPlain
        case .changeFolderName(_, _, let changeName):
            var formData = [MultipartFormData]()
            let parameters = ["folderName": changeName]
            for (key, value) in parameters {
                formData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
            }
            return .uploadMultipart(formData)
        }
    }
    
        
    var headers: [String : String]? {
        if let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) {
            return ["Authorization": jwtToken]
        }
        return nil
    }
    

}
