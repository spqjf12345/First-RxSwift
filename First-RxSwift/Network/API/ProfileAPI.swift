//
//  ProfileAPI.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/09.
//

import Foundation
import Moya

enum ProfileAPI {
    case getUserInfo(userId: Int)
    case changeUserImage(userId: Int, image: Data)
    case changeUserNickName(userId: Int, nickName: String)
    case verifyPassword(userId: Int, password: String)
    case updatePassword(userId: Int, password: String)
    case quitApp(userId: Int)
    case allowAlarmNoti(userId: Int)
    case getBookMark(userId: Int)
}

extension ProfileAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .getUserInfo(let userId), .changeUserImage(let userId, _), .changeUserNickName(let userId, _), .updatePassword(let userId, _), .quitApp(let userId):
            return "/users/\(userId)"
        case .verifyPassword(let userId, _):
            return "/users/\(userId)/verify"
        case .allowAlarmNoti(let userId):
            return "/users/\(userId)/alarm"
        case .getBookMark(let userId):
            return "/users/\(userId)/bookmark"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo(_), .getBookMark(_):
            return .get
        case .verifyPassword(_, _):
            return .post
        case .allowAlarmNoti(_), .updatePassword(_, _), .changeUserNickName(_, _), .changeUserImage(_, _):
            return .patch
        case .quitApp(_):
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getUserInfo(_), .getBookMark(_), .allowAlarmNoti(_), .quitApp(_):
            return .requestPlain
        case .updatePassword(_, let password):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .data("\(password)".data(using: .utf8)!), name: "updatePassword"))
            return .uploadMultipart(multipartFormData)
        case .verifyPassword(_, let password):
            return .requestParameters(parameters: ["password" : password], encoding: JSONEncoding.default)
        case .changeUserNickName(_, let nickName):
            var multipartFormData = [MultipartFormData]()
            multipartFormData.append(MultipartFormData(provider: .data("\(nickName)".data(using: .utf8)!), name: "updateNickname"))
            return .uploadMultipart(multipartFormData)
        case .changeUserImage(_, let image):
            var multipartFormData = [MultipartFormData]()
            var fileName = "\(image).jpg"
            fileName = fileName.replacingOccurrences(of: " ", with: "_")
            multipartFormData.append(MultipartFormData(provider: .data(image), name: "imageFile", fileName: fileName, mimeType: "image/jpg"))
            return .uploadMultipart(multipartFormData)

        }
    }
    
    var headers: [String : String]? {
        guard let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) else { return nil }
        
        switch self {
        case .quitApp(_):
            return ["Authorization" : jwtToken,
                    "Content-Type" :"application/json"]
        case .getUserInfo(let userId), .verifyPassword(let userId, _) ,.allowAlarmNoti(let userId), .getBookMark(let userId):
            return   ["Authorization" : jwtToken, "userId" : "\(userId)", "Content-Type" :"application/json"]

        default: return ["Authorization" : jwtToken]
        }
    }
}
