//
//  AppService.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/19.
//

import Foundation

struct AppService: HasLoginJoinService {
    let folderService: FolderService
    let loginJoinService: LoginJoinService
}
