//
//  TextInViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/11.
//

import Foundation
import RxCocoa

class TextInViewModel{
    var services: TextService!
    
    public let folderId: Int

    init(folderId id: Int) {
        self.folderId = id
    }
}
