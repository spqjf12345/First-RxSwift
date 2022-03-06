//
//  AllBoxViewModel.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import Foundation
import RxSwift
import RxCocoa
import PhotosUI

class AllBoxViewModel {
    var disposeBag = DisposeBag()

    init(selected: Folder){
        getFolders()
    }
    
    struct Input {
        let searchTextField: Observable<Void>
        let refreshEvent: Observable<Void>
        let floatingButtonTap: Observable<Void>
        let folderCellTap: Observable<Int> // folderId
        let chageFolderNameTap: Observable<Void>
        let changeFolderImageTap: Observable<Void>
        let deleteFolder: Observable<Void>
        let sortingButtonTap: Observable<Void>
    }
  
    struct Output {
        var folderCount: Observable<String> //개의 폴더
        var sortingText: Observable<String> //이름순, 생성순, 최신순
        var folders = BehaviorSubject<[Folder]>(value: [])
        var selectedFolders: Folder
        var filteredFolders = BehaviorSubject<[Folder]>(value: [])
    }
    
    func getFolders(){
        //getfolder
        
    }
    
    
    
}
