//
//  Gift.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import RxDataSources

struct Gift: Codable {
    var timeoutId: Int
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
    var imageData: Data?
}

struct CreateGift: Codable {
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
    var imageFile: Data
}

struct UpdateGift: Codable {
    var timeoutId: Int
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
}

struct SectionOfGift {
    var items: [Gift]
}


extension SectionOfGift: SectionModelType {
    init(original: SectionOfGift, items: [Gift]){
        self = original
        self.items = items
    }
}
