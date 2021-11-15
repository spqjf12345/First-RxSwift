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

extension ArticleList {
    
    static var all: Resource<ArticleList> = {
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=cbe61b0ac36141ab8cd720cdc0b2e3b6")!
        return Resource(url: url)
    }()
}

struct Article: Codable {
    var title: String
    var description: String
}
