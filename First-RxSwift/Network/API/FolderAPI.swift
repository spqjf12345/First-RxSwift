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
    case changeFolderImage(userId:Int, folderId: Int, imageData: Data)
    case deleteFolder(userId:Int, folderId: Int)
    case createFolder(userId: Int, folderRequest: CreateFolderRequest)
    
}

extension FolderAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .getFolders(let userId), .createFolder(let userId, _):
            return "/users/\(userId)/folders"
        case .viewFolder(let userId, let folderId):
            return "/users/\(userId)/folders/\(folderId)"
        case .changeFolderName(let userId, let folderId, _), .changeFolderImage(let userId, let folderId, _), .deleteFolder(let userId, let folderId):
            return "/users/\(userId)/folders/\(folderId)"
        
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .createFolder:
            return .post
        case .getFolders:
            return .get
        case .viewFolder:
            return .get
        case .changeFolderName, .changeFolderImage:
            return .patch
        case .deleteFolder:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getFolders:
            return .requestPlain
        case .viewFolder, .deleteFolder:
            return .requestPlain
        case .changeFolderName(_, _, let changeName):
            var multipartFormData = [MultipartFormData]()
            let parameters = ["folderName": changeName]
            for (key, value) in parameters {
                multipartFormData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
            }
            //print("foldername \(multipartFormData)")
            return .uploadMultipart(multipartFormData)
            
        case .changeFolderImage(_, _, let changeImage):
            var multipartFormData = [MultipartFormData]()
            var fileName = "\(changeImage).jpg"
            fileName = fileName.replacingOccurrences(of: " ", with: "_")
            print(fileName)
            multipartFormData.append(MultipartFormData(provider: .data(changeImage), name: "imageFile", fileName: fileName, mimeType: "image/jpg"))
            return .uploadMultipart(multipartFormData)
            
        case .createFolder(_, let folder):
            var multipartFormData = [MultipartFormData]()
            let parameter: [String: Any]
            if(folder.parentFolderId == 0){
                parameter = CreateFolderRequestNull(folderName: folder.folderName, userId: folder.userId, type: folder.type).dictionary
            }else {
                parameter = CreateFolderRequestParameter(parentFolderId: folder.parentFolderId, folderName: folder.folderName, userId: folder.userId, type: folder.type).dictionary
            }
            
            var fileName = "\(folder.imageFile).jpg"
            fileName = fileName.replacingOccurrences(of: " ", with: "_")
            print(fileName)
            multipartFormData.append(MultipartFormData(provider: .data(folder.imageFile), name: "imageFile", fileName: fileName, mimeType: "image/jpg"))
        
            for (key, value) in parameter {
                multipartFormData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
            }
            
            return .uploadMultipart(multipartFormData)
        }
    }
    
        
    var headers: [String : String]? {
        if let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) {
            return ["Authorization": jwtToken]
        }
        return nil
    }
    

}
