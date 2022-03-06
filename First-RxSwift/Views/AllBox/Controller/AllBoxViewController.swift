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
import RxFlow

class AllBoxViewController: UIViewController, Stepper {
    
    var steps = PublishRelay<Step>()
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var folderCollectionView: UICollectionView!
    @IBOutlet weak var floatingButton: UIButton!
    
    private var disposeBag = DisposeBag()
    private var alertController = UIAlertController()
    private var tblView = UITableView()
    
    
    private var viewModel = AllBoxViewModel(selected: Folder.Empty)
    
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
        setUpCollectionviewBinding()
        bindViewModel()
    }
    
    func setUpCollectionviewBinding(){
        folderCollectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        folderCollectionView.allowsSelection = true
        folderCollectionView.isUserInteractionEnabled = true
//        folderCollectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        folderCollectionView.rx.modelSelected(Folder.self)
            .subscribe(onNext: { data in
                //folder selected 정보 전달
                if data.type == "PHRASE" {
                    self.steps.accept(AllStep.textIn)
                }else if data.type == "LINK" {
                    self.steps.accept(AllStep.linkIn)
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func bindViewModel(){
        viewModel.folders
            .filter { !$0.isEmpty }
            .bind(to: folderCollectionView.rx.items(cellIdentifier: FolderCollectionViewCell.identifier, cellType: FolderCollectionViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
    }
    
    
}

extension AllBoxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 3
        return CGSize(width: cellWidth, height: cellWidth/0.6)
    }
}
