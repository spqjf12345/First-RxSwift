//
//  GiftUseCase.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/04/29.
//

import Foundation
import RxSwift

protocol GiftUseCaseType {
    func getGifticon()
    func updateGifticon() //-> image, data
    func deleteGifticon()
    func makeGifticon()
    func usedGofticon()
}

class GiftUseCase: GiftUseCaseType {
    
    private let giftRepository: GiftRepositoryType
    
    var disposeBag = DisposeBag()
    
    init(repository: GiftRepositoryType) {
        self.giftRepository = repository
    }
    
    func getGifticon() {
        <#code#>
    }
    
    func updateGifticon() {
        <#code#>
    }
    
    func deleteGifticon() {
        <#code#>
    }
    
    func makeGifticon() {
        <#code#>
    }
    
    func usedGofticon() {
        <#code#>
    }
}
