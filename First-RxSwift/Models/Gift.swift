//
//  Gift.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation

struct Gift {
    var timeoutId: Int
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
    var imageData: Data?
}

struct createGift {
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
    var imageFile: Data
}

struct updateGift {
    var timeoutId: Int
    var userId: Int
    var title: String
    var deadline: String
    var isValid: Bool
    var selected: [Int]
}
