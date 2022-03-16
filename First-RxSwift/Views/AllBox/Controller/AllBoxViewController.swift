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
    private var alertController = UIAlertController()
    private var tblView = UITableView()
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
        folderCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 50, right: 15)
        folderCollectionView.register(FolderCollectionViewCell.nib(), forCellWithReuseIdentifier: FolderCollectionViewCell.identifier)
        folderCollectionView.register(UINib(nibName: HeaderView.reuseIdentifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.reuseIdentifier)
        folderCollectionView.refreshControl = self.refreshControl
        folderCollectionView.allowsSelection = true
        folderCollectionView.isUserInteractionEnabled = true
//        folderCollectionView.rx.setDataSource(self).disposed(by: disposeBag)
//        folderCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfFolder>(
            configureCell: { datasource, collectionview, indexPath, item in
                let cell = collectionview.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier, for: indexPath) as! FolderCollectionViewCell
                cell.moreButton.rx.tap
                    .asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self = self else { return }
                        self.more_dropDown.anchorView = cell.moreButton
                        self.more_dropDown.show()
                        self.more_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                            let folderId = self.viewModel.findFolderId(indexPath.row)
                            print("selected \(folderId)")
                            if index == 0 { // 이름 변경
                                self.editFolderName(folderId: folderId, completionHandler: {(response) in
                                    cell.folderName.text = response
                                    self.showAlert(title: "이름 변경 완료", message: "폴더 이름이 수정되었습니다", style: .alert, actions: [])
                                })
                            }else if index == 1 {
                                
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
        headerView?.updateFolderCount(count: viewModel.folderCount)
    }
    
    func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(sortingTap(_:)), name: Notification.Name(rawValue: "SortingTap"), object: nil)
    }
    
    @objc func sortingTap(_ notification: Notification){
        guard let index = notification.object as? IndexPath else { return }
        viewModel.sortBy(index.row)
    }
    
    
    func bindViewModel(){
        //let observable = Observable.of(viewModel.folders)
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

    }
    
    func showSortingTap(){
        let sortingView = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(withIdentifier: "SortingView") as! SortingView
        sortingView.modalPresentationStyle = .overCurrentContext
        sortingView.modalTransitionStyle = .coverVertical
        print("hhee")
        present(sortingView, animated: true)
    }
    
    
}

extension AllBoxViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.folderCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FolderCollectionViewCell.identifier, for: indexPath) as? FolderCollectionViewCell else { return UICollectionViewCell() }
        print("datasource \(viewModel.folders[0].items[indexPath.row])")
        cell.configure(with: viewModel.folders[0].items[indexPath.row])
        return cell
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
//                FolderService.shared.changeFolderName(folderId: folderId, changeName: userInput, errorHandler: { (error) in})
                completionHandler(userInput)
            }
            
            
           
        })
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertVC.addAction(editAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
        
        
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
        let vc = UIStoryboard(name: "AllMain", bundle: nil).instantiateViewController(identifier: "MakeFolderViewController") as! MakeFolderViewController
        MakeFolderViewController.type_dropDown.dataSource = ["텍스트", "링크"]
        self.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        //self.navigationController?.pushViewController(vc, animated: true)
    }
}
