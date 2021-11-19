//
//  URL.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/19.
//

import Foundation

extension URL {
    static func urlForWeatherAPI(city: String) -> URL? {
        return URL(string: "api.openweathermap.org/data/2.5/weather?q=\(city)&appid=bbf46cc5bb562b19afc06ce5325199a9")
    }
}
