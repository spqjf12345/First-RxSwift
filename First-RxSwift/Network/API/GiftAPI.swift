//
//  GiftAPI.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import Moya

enum GiftAPI {
    case getGift
    case usedGift(giftId: Int)
    case updateGiftImage(giftId: Int, image: Data)
    case updateGiftData(giftId: Int, gift: Gift)
}
