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
    var headerView: HeaderView?
    
    private var disposeBag = DisposeBag()
    var selectedCellIndexPath = IndexPath()
   
    let sortingButton = UIButton()
    
    private lazy var refreshControl = UIRefreshControl()

    private var viewModel = AllBoxViewModel(folderUseCase: FolderUseCase(repository: FolderRepository(folderService: FolderService())))
    
    var more_dropDown: DropDown = {
        var dropDown = DropDown()
        dropDown.width = 100
        dropDown.backgroundColor = .white
        dropDown.dataSource = ["이름 변경", "이미지 변경", "폴더 삭제"]
        return dropDown
    }()
    
    
    
    var dataSource: RxCollectionViewSectionedReloadDataSource<SectionOfFolder>!
    
    private var folderNameTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionviewBinding()
        setUpUI()
        addObserver()
        bindViewModel()
    }

    
    func setUpCollectionviewBinding(){
        folderCollectionView.delegate = self
        folderCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 15, right: 15)
        folderCollectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        folderCollectionView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        folderCollectionView.refreshControl = self.refreshControl
        folderCollectionView.allowsSelection = true
        folderCollectionView.isUserInteractionEnabled = true
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
    
    func setUpUI(){
        searchTextfield.layer.cornerRadius = 15
        headerView?.updateFolderCount(count: viewModel.folderCount)
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
        folderCollectionView.reloadData()
    }
    
    func presentPicker(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func bindViewModel(){
        viewModel.folderUseCase.folders
            .bind(to: folderCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let input = AllBoxViewModel.Input (
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
        refreshEvent: self.refreshControl.rx.controlEvent(.valueChanged).asObservable(),
        searchTextField: self.searchTextfield.rx.text.orEmpty.asObservable(),
        floatingButtonTap: self.floatingButton.rx.tap.asObservable(),
        folderCellTap: self.folderCollectionView.rx.itemSelected.map { $0 },
            folderMoreButtonTap :self.folderCollectionView.rx.itemSelected.map { $0.row },
        sortingButtonTap: self.sortingButton.rx.tap.asObservable()
        )
        
        
        input.floatingButtonTap
            .subscribe(onNext: {
                self.navigateToMakeFolder()
            }).disposed(by: disposeBag)

        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)

        output.reloadData
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
            .drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
        
        output.didFilderedFolder
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.folderCollectionView.reloadData()
            }).disposed(by: disposeBag)
        
        output.selectedFolder
            .subscribe(onNext: { [weak self] respone in
                guard let self = self else { return }
                self.navigateToInVC(response: respone)
            }).disposed(by: disposeBag)

    }
    
    func showSortingTap(){
        let sortingView = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "SortingView") as! SortingView
        sortingView.modalPresentationStyle = .overCurrentContext
        sortingView.modalTransitionStyle = .coverVertical
        present(sortingView, animated: true)
    }
    
    
}
extension AllBoxViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     
        let width: CGFloat = (view.frame.width - 47) / 2
        let height: CGFloat = 180
        return CGSize(width: width, height: height)

    }
}

extension AllBoxViewController {
    func editFolderName(folderId: Int, completionHandler: @escaping ((String) -> Void)){
        let alertVC = UIAlertController(title: "폴더 이름 수정", message: nil, preferredStyle: .alert)
       
        alertVC.addTextField(configurationHandler: { (textField) -> Void in
            self.folderNameTextField = textField
            self.folderNameTextField.placeholder = "새로 수정할 아이디를 입력해주세요"
        })
        let label = UILabel(frame:CGRect(x: 0, y: 40, width: 270, height:18))
        
        let editAction = UIAlertAction(title: "수정", style: .default, handler: { [self] (action) -> Void in
            guard let userInput = self.folderNameTextField.text else {
                return
            }
            label.isHidden = true
            label.textColor = .red
            label.font = label.font.withSize(12)
            label.textAlignment = .center
            label.text = ""
            alertVC.view.addSubview(label)
            
            if userInput == ""{
                label.text = "이름을 입력해주세요"
                label.isHidden = false
                self.present(alertVC, animated: true, completion: nil)

            }else {
                viewModel.changeFolderName(folderId: folderId, changeName: userInput)
                completionHandler(userInput)
            }
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertVC.addAction(editAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
        
        
    }
}

extension AllBoxViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                if let image = image as? UIImage {
                    print("selectedCellIndexPath \(selectedCellIndexPath)")
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

extension AllBoxViewController {
    private func navigateToMakeFolder() {
        let vc = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(identifier: "MakeFolderViewController") as! MakeFolderViewController
        MakeFolderViewController.type_dropDown.dataSource = ["텍스트", "링크"]
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func navigateToInVC(response: SelectedFolderType) {
        switch response.type {
        case "PHRASE":
            let storyBoard = UIStoryboard(name: "Phrase", bundle: nil)
            guard let textInVC = storyBoard.instantiateViewController(identifier: "textIn") as? TextInViewController else { return }
            self.navigationController?.pushViewController(textInVC, animated: true)
        case "LINK" :
            let storyBoard = UIStoryboard(name: "Link", bundle: nil)
            guard let linkInVC = storyBoard.instantiateViewController(identifier: "linkFolderIn") as? LinkInViewController else { return }
            self.navigationController?.pushViewController(linkInVC, animated: true)
        default:
            print("nothing")
        }
    }
}
