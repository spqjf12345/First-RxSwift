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
    var folders = BehaviorSubject<[Folder]>(value: [])
    var selectedFolders: Folder
    var filteredFolders = BehaviorSubject<[Folder]>(value: [])
    var disposeBag = DisposeBag()

    init(selected: Folder){
        self.selectedFolders = selected
        getFolders()
    }
  
    func getFolders(){
        //getfolder
    }
    
    
    
}
