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
import RxDataSources

class AllBoxViewController: UIViewController {
    
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var folderCollectionView: UICollectionView!
    @IBOutlet weak var floatingButton: UIButton!
    var headerView = HeaderView()
    
    private var disposeBag = DisposeBag()
    private var alertController = UIAlertController()
    private var tblView = UITableView()
    let sortingButton = UIButton()
    
    private lazy var refreshControl = UIRefreshControl()

    private var viewModel = AllBoxViewModel(folderUseCase: FolderUseCase(repository: FolderRepository(folderService: FolderService())))
    
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
        print("AllBoxViewController")
    }
    
    func setUpCollectionviewBinding(){
        folderCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        folderCollectionView.allowsSelection = true
        folderCollectionView.isUserInteractionEnabled = true
        
        folderCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        folderCollectionView.rx.setDataSource(self)
            .disposed(by: disposeBag)
        
//        folderCollectionView.rx.modelSelected(Folder.self)
//            .subscribe(onNext: { data in
//                //folder selected 정보 전달
//                if data.type == "PHRASE" {
//                    self.steps.accept(AllStep.textIn(folderId: folderId))
//                }else if data.type == "LINK" {
//                    self.steps.accept(AllStep.linkIn(folderId: folderId))
//                }
//                
//            }).disposed(by: disposeBag)
        
    }
    
    func bindViewModel(){
//        viewModel.folders
//            .filter { !$0.isEmpty }
//            .bind(to: folderCollectionView.rx.items(cellIdentifier: FolderCollectionViewCell.identifier, cellType: FolderCollectionViewCell.self)) { row, element, cell in
//                cell.configure(with: element)
//            }.disposed(by: disposeBag)
        
        let input = AllBoxViewModel.Input (
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
        refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
            searchTextField: self.searchTextfield.rx.text.orEmpty.asObservable(),
        floatingButtonTap: self.floatingButton.rx.tap.asObservable(),
            folderCellTap: self.folderCollectionView.rx.itemSelected.map { $0 },
            folderMoreButtonTap :self.folderCollectionView.rx.itemSelected.map { $0.row },
        chageFolderNameTap: self.folderCollectionView.rx.itemSelected.map { $0.row },
        changeFolderImageTap: self.folderCollectionView.rx.itemSelected.map { $0.row },
        deleteFolder: self.folderCollectionView.rx.itemSelected.map { $0.row },
        sortingButtonTap: self.sortingButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        viewModel.folders
            .filter{ !$0.isEmpty }
            .bind(to: folderCollectionView.rx.items(cellIdentifier: FolderCollectionViewCell.identifier, cellType: FolderCollectionViewCell.self)) { row, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
            
        

    }
    
    
}

extension AllBoxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else { fatalError() }
            self.headerView = headerView
            
        default:
            fatalError()
        }
    }
}

extension AllBoxViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.bounds.width
//        let cellWidth = (width - 30) / 2
//        return CGSize(width: cellWidth, height: cellWidth / 2)
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 200
        return CGSize(width: width, height: height)
    }
}

extension AllBoxViewController {
    private func navigateToMakeFolder() {
        let vc = self.storyboard?.instantiateViewController(identifier: "MakeFolderViewController") as! MakeFolderViewController
       // vc.type_dropDown.dataSource = ["텍스트", "링크"]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
