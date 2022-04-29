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
            return .requestPlain
        case .updateGiftImage(_, _, let image):
            return .requestPlain
        case .updateGiftData(_, _, let gift):
            return .requestPlain
        
        }
    }
    
    var headers: [String : String]? {
        if let jwtToken = UserDefaults.standard.string(forKey: UserDefaultKey.jwtToken) {
            return ["Authorization": jwtToken]
        }
        return nil
    }
    
}
