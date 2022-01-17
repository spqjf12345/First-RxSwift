//
//  Task.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/13.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
    
}

struct Tasks {
    let title: String
    let priority: Priority
}
