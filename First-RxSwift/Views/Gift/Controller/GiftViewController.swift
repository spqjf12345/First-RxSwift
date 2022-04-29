//
//  GiftViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import DropDown
import PhotosUI
import RxSwift
import RxCocoa
import RxDataSources

class GiftViewController: UIViewController {

    let refreshControl = UIRefreshControl()
    @IBOutlet weak var floatingButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let more_dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.width = 100
        dropDown.dataSource = ["알림 수정", "사용 완료"]
        return dropDown
    }()
    
    var headerView: HeaderView?
    private var disposeBag = DisposeBag()
    var selectedCellIndexPath = IndexPath()
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfFolder>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionviewBinding()
    }
    
    func setUpCollectionviewBinding(){
        collectionView.delegate = self
        collectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.refreshControl = self.refreshControl
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfFolder>(
            configureCell: { datasource, collectionview, indexPath, item in
                let cell = collectionview.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier, for: indexPath) as! FolderCollectionViewCell
                cell.moreButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.more_dropDown.anchorView = cell.moreButton
                        self.selectedCellIndexPath = indexPath
                        self.more_dropDown.show()
                        self.more_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            let folderId = self.viewModel.findFolderId(indexPath.row)
                            if index == 0 { // 이름 변경
                                self.editFolderName(folderId: folderId, completionHandler: {(response) in
                                    cell.folderName.text = response
                                    self.alertViewController(title: "이름 변경 완료", message: "폴더 이름이 수정되었습니다", completion: { str in })
                                })
                            }else if index == 1 {
                                self.presentPicker()
                            }else if index == 2 {
                                self.viewModel.deleteFolder(folderId: folderId)
                                self.alertViewController(title: "폴더 삭제 완료", message: "폴더가 삭제 되었습니다", completion: { str in
                                    self.folderCollectionView.reloadData()
                                })
                            }
                        }
                        self.more_dropDown.clearSelection()
                    }).disposed(by: cell.disposeBag)
                cell.configure(with: item)
                return cell
            })
        
        
        
        
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else { fatalError() }
            
            headerView.updateFolderCount(count: self.viewModel.folderCount)
            headerView.sortingButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.showSortingTap()
                }).disposed(by: self.disposeBag)
            self.headerView = headerView
            return headerView
        }
    }


}
