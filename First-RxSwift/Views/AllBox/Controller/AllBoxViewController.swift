//
//  AllBoxViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import PhotosUI
import DropDown
import RxSwift
import RxCocoa

class AllBoxViewController: UIViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var folderCollectionView: UICollectionView!
    @IBOutlet weak var floatingButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private var alertController = UIAlertController()
    private var tblView = UITableView()
    
    
    private var viewModel = AllBoxViewModel()
    
    let more_dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.width = 100
        dropDown.dataSource = ["이름 변경", "이미지 변경", "폴더 삭제"]
        return dropDown
    }()
    
    private var folderNameTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewSetting(collectionView: folderCollectionView)
    }
    
    func collectionViewSetting(collectionView: UICollectionView){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
    }
    


}
