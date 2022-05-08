//
//  GiftViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture

class GiftViewController: UIViewController, UIGestureRecognizerDelegate {

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
        addObserver()
        setupUI()
    }
    
    func setupUI(){
        searchTextField.layer.cornerRadius = 15
        searchTextField.clipsToBounds = true
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0));
        searchTextField.leftViewMode = .always
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(sortingTap(_:)), name: Notification.Name(rawValue: "SortingTap"), object: nil)
    }
    
    @objc func sortingTap(_ notification: Notification){
        guard let index = notification.object as? IndexPath else { return }
        SortingView.sortList.subscribe(onNext: { str in
            let text = str[index.row]
            self.headerView?.sortingButton.setTitle(text, for: .normal)
        }).disposed(by: disposeBag)
        
        viewModel.sortBy(index.row)
        collectionView.reloadData()
    }
    
    func setUpCollectionviewBinding(){
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        collectionView.register(TimeOutCollectionViewCell.nib(), forCellWithReuseIdentifier: TimeOutCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        
        let longPressedGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.5
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        self.collectionView.addGestureRecognizer(longPressedGesture)
        
        collectionView.refreshControl = self.refreshControl
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfGift>(
            configureCell: { datasource, collectionview, indexPath, item in
                let cell = collectionview.dequeueReusableCell(withReuseIdentifier: TimeOutCollectionViewCell.identifier, for: indexPath) as! TimeOutCollectionViewCell
                cell.moreButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.more_dropDown.anchorView = cell.moreButton
                        self.selectedCellIndexPath = indexPath
                        self.more_dropDown.show()
                        self.more_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            let giftId = self.viewModel.findGiftId(index: indexPath.row)
                            if index == 0 { // 알림 수정
                              print("알림 수정")
                            }else if index == 1 { // 사용 완료
                                print("사용 완료")
                            }
                        }
                        self.more_dropDown.clearSelection()
                    }).disposed(by: cell.disposeBag)
                cell.configure(model: item)
                return cell
            })

        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier, for: indexPath) as? HeaderView else { fatalError() }
            
            headerView.updateCount(text: "\(self.viewModel.count)개의 기프티콘")
            headerView.sortingButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.showSortingTap()
                }).disposed(by: self.disposeBag)
            self.headerView = headerView
            return headerView
        }
    }
    
    @objc func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
        if (gestureRecognizer.state != .began) {
                return
            }

        let p = gestureRecognizer.location(in: collectionView)

        if let indexPath = collectionView?.indexPathForItem(at: p) {
            self.alertWithNoViewController(title: "알림 삭제", message: "알림을 삭제 하시겠습니까?", completion: { [self] (response) in
                    if (response == "OK") {
                        let index = indexPath.row
                        let giftId = self.viewModel.findGiftId(index: index)
                        viewModel.deleteGifticon(giftId: giftId)

                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        self.alertViewController(title: "삭제 완료", message: "알림이 삭제 되었습니다.", completion: {(response) in
                            self.viewModel.deleteGifticon(giftId: giftId)
                        })
                       }
                })
            }

    }
    
    private func bindViewModel(){
        
        viewModel.giftUsecase.gifticon
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let input = GiftViewModel.Input (
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
        refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
        searchTextField: self.searchTextField.rx.text.orEmpty.asObservable(),
        floatingButtonTap: self.floatingButton.rx.tap.asObservable(),
        giftCellTap: self.collectionView.rx.itemSelected.map { $0 },
            folderMoreButtonTap :self.collectionView.rx.itemSelected.map { $0.row }
       // sortingButtonTap: self.headerView?.sortingButton.rx.tap.asObservable(),
//            deleteTap: self.collectionView.rx.a
        )
        
        input.floatingButtonTap
            .bind(onNext: navigateToCreateGifticon)
            .disposed(by: self.disposeBag)
        
        input.giftCellTap
            .bind(onNext: { [weak self] index in
                guard let self = self else { return }
                if self.viewModel.checkIsValid(index: index) {
                    self.navigateToDetailGift()
                }
            }).disposed(by: disposeBag)
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        output.didFilderedGift
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.collectionView.reloadData()
            }).disposed(by: disposeBag)
    }


}

extension GiftViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = view.frame.height / 2
        return CGSize(width: width, height: height)

    }
}

extension GiftViewController {
    private func showSortingTap(){
        let sortingView = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "SortingView") as! SortingView
        sortingView.modalPresentationStyle = .overCurrentContext
        sortingView.modalTransitionStyle = .coverVertical
        present(sortingView, animated: true)
    }
    
    private func navigateToCreateGifticon(){
        let addGiftVC = UIStoryboard(name: "Timeout", bundle: nil).instantiateViewController(withIdentifier: "AddGiftViewController")
        self.navigationController?.pushViewController(addGiftVC, animated: true)
    }
    
    private func navigateToDetailGift(){
        let viewNotiVC =  UIStoryboard(name: "Timeout", bundle: nil).instantiateViewController(identifier: "ViewNotiController")
        self.navigationController?.pushViewController(viewNotiVC, animated: true)
    }
    
}

//extension GiftViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        let itemProvider = results.first?.itemProvider
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
//                if let image = image as? UIImage {
//                    let folderId = self.viewModel.findGiftId(index: selectedCellIndexPath.row)
//                    self.viewModel.changeFolderImage(folderId: folderId, imageData: image.pngData()!)
//                    DispatchQueue.main.async {
//                        self.alertViewController(title: "이미지 변경", message: "이미지가 변경되었습니다", completion: { str in })
//                    }
//                } else { // TODO: Handle empty results or item providernot being able load UIImage
//            print("can't load image")
//                }
//                }
//        }
//
//    }
//}
