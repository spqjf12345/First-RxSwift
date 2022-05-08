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
import RxGesture

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
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfGift>!
    
    private var viewModel = GiftViewModel(giftUsecase: GiftUseCase(repository: GiftReposotory(giftService: GiftService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionviewBinding()
        bindViewModel()
    }
    
    func setUpCollectionviewBinding(){
        collectionView.delegate = self
        collectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.refreshControl = self.refreshControl
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfGift>(
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
                            let giftId = self.viewModel.findGiftId(indexPath.row)
                            if index == 0 { // 알림 수정
                              
                            }else if index == 1 { // 사용 완료
                                
                            }
                        }
                        self.more_dropDown.clearSelection()
                    }).disposed(by: cell.disposeBag)
                cell.configure(with: item)
                return cell
            })
        
        
        
        
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else { fatalError() }
            
            headerView.updateFolderCount(count: self.viewModel.count)
            self.headerView = headerView
            return headerView
        }
    }
    
    private func bindViewModel(){
        let input = GiftViewModel.Input (
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
        refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
        searchTextField: self.searchTextField.rx.text.orEmpty.asObservable(),
        floatingButtonTap: self.floatingButton.rx.tap.asObservable(),
        giftCellTap: self.collectionView.rx.itemSelected.map { $0 },
            folderMoreButtonTap :self.collectionView.rx.itemSelected.map { $0.row },
        sortingButtonTap: self.headerView!.sortingButton.rx.tap.asObservable(),
        deleteTap: self.collectionView.rx.longPressGesture()
        )
        
        input.sortingButtonTap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showSortingTap()
            }).disposed(by: self.disposeBag)
        
        input.floatingButtonTap
            .bind(onNext: navigateToCreateGifticon)
            .disposed(by: self.disposeBag)
        
        input.giftCellTap
            .bind(onNext: { index in
                viewModel.
            }).disposed(by: disposeBag)
    }


}

extension GiftViewController: UICollectionViewDelegate {
    
}

extension GiftViewController {
    private func showSortingTap(){
        let sortingView = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "SortingView") as! SortingView
        sortingView.modalPresentationStyle = .overCurrentContext
        sortingView.modalTransitionStyle = .coverVertical
        present(sortingView, animated: true)
    }
    
    private func navigateToCreateGifticon(){
        let giftVC = UIStoryboard(name: "Timeout", bundle: nil).instantiateViewController(withIdentifier: "MakeNotiFolderViewController")
        self.navigationController?.pushViewController(giftVC, animated: true)
    }
    
    private func presentPicker(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func navigateToDetailGift(){
        let viewNotiVC =  UIStoryboard(name: "Timeout", bundle: nil).instantiateViewController(identifier: "ViewNotiController")
        self.navigationController?.pushViewController(viewNotiVC, animated: true)
    }
    
}

extension GiftViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                if let image = image as? UIImage {
                    let folderId = self.viewModel.findFolderId(selectedCellIndexPath.row)
                    self.viewModel.changeFolderImage(folderId: folderId, imageData: image.pngData()!)
                    DispatchQueue.main.async {
                        self.alertViewController(title: "이미지 변경", message: "이미지가 변경되었습니다", completion: { str in })
                    }
                } else { // TODO: Handle empty results or item providernot being able load UIImage
            print("can't load image")
                }
                }
        }

    }
}
