//
//  signUpValidate.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/26.
//

import Foundation

enum ValidationState: Equatable {
    case success
    case failure
    
    var description: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}

struct JSON {
    static let encoder = JSONEncoder()
}

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}
