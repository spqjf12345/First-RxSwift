//
//  GiftAPI.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import Moya

enum GiftAPI {
    case getGift(userId: Int)
    case createGift(userId: Int, gift: CreateGift)
    case usedGift(userId: Int, giftId: Int)
    case updateGiftImage(userId: Int, giftId: Int, image: Data)
    case updateGiftData(userId: Int, giftId: Int, gift: UpdateGift)
    case deleteGift(userId: Int, giftId: Int)
}

extension GiftAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: Config.base_url)!
    }
    
    var path: String {
        switch self {
        case .getGift(let userId), .createGift(let userId, _):
            return "/users/\(userId)/timeouts"
        case .usedGift(_, let giftId):
            return "/timeouts/\(giftId)/valid"
        case .updateGiftImage(let userId, let giftId, _), .updateGiftData(let userId, let giftId, _), .deleteGift(let userId, let giftId):
            return "/users/\(userId)/timeouts/\(giftId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGift:
            return .get
        case .createGift:
            return .post
        case .updateGiftImage, .updateGiftData, .usedGift:
            return .patch
        case .deleteGift:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getGift, .usedGift, .deleteGift:
            return .requestPlain
        case .createGift( _, let gift):
            var multipartFormData = [MultipartFormData]()
            let parameter: [String: Any] = ["userId" : gift.userId,
                                            "title" : gift.title,
                                            "deadline" : gift.deadline,
                                            "isValid" : gift.isValid,
                                            "selected" : gift.selected ]
            print(parameter)
            var fileName = "\(gift.imageFile).jpg"
            fileName = fileName.replacingOccurrences(of: " ", with: "_")
            multipartFormData.append(MultipartFormData(provider: .data(gift.imageFile), name: "imageFile", fileName: fileName, mimeType: "image/jpg"))
            
            for (key, value) in parameter {
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        if let string = element as? String {
                            multipartFormData.append(MultipartFormData(provider: .data("\(string)".data(using: .utf8)!), name: key))
                            
                        } else
                            if let num = element as? Int { // tags, amentities
                                let value = "\(num)"
                            multipartFormData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
                        }
                    })
                    print(temp)
                } else {
                    multipartFormData.append(MultipartFormData(provider: .data("\(value)".data(using: .utf8)!), name: key))
                    print("\(key) : \(value)")
                }
            }

            
            print("multi \(multipartFormData)")
            return .uploadMultipart(multipartFormData)

        case .updateGiftImage(_, _, let image):
            var multipartFormData = [MultipartFormData]()
            
            let createdAt = String(Int(Date().timeIntervalSince1970 * 1000))
            multipartFormData.append(MultipartFormData(provider: .data(image), name: "imageFile", fileName: "\(createdAt).jpeg", mimeType: "image/jpeg"))
            return .uploadMultipart(multipartFormData)
        case .updateGiftData(_, _, let gift):
            var multipartFormData = [MultipartFormData]()
            for (key, value) in gift.dictionary {
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
