//
//  Article.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/15.
//

import Foundation

struct ArticleList: Decodable {
    let articles: [Article]
}

struct Article: Codable {
    var title: String
    var description: String
}
