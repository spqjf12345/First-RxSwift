//
//  Folder.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/06.
//

import Foundation

struct Folder: Codable {
    var folderId: Int
    var folderName: String
    var userId: Int
    var type: String
    var imageData: Data?
    
    init(folderId: Int, folderName: String, userId: Int, imageData: Data, type: String){
        self.folderId = folderId
        self.folderName = folderName
        self.userId = userId
        self.type = type
        self.imageData = imageData
    }
}

extension Folder {
    static var Empty = Folder(folderId: 0, folderName: "", userId: 0, imageData: Data(), type: "")
}

struct ViewFolderResponse: Codable {
    var phraseFolderList: [PhraseFolder]
    var lineFolderList: [LintFolder]
}

struct PhraseFolder: Codable {
    var phraseId: Int

    var text: String
    
    var bookmark: Bool
    
    var textDate: String
}

struct LintFolder: Codable {
    var linkId: Int

    var title: String
    
    var link: String
    
    var bookmark: Bool
}



