//
//  TextInViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/11.
//

import Foundation
import RxFlow
import RxCocoa

class TextInViewModel: Stepper, ServicesViewModel {
    var services: TextService!
    
    typealias Services = TextService
    
    var steps = PublishRelay<Step>()
    
    public let folderId: Int

    init(folderId id: Int) {
        self.folderId = id
    }
}
