//
//  ProfileViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController {

    enum Section: CaseIterable {
        case main
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var versionLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 42, height: 20))
        var version: String? {
            guard let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String else { return ""}
            return version
        }
        label.text = version
        return label
    }()
    
    let list : [String] = ["내 북마크", "알림 허용", "버전 정보", "로그 아웃"]
    let disposeBag = DisposeBag()
    var dataSource: UITableViewDiffableDataSource<Section, String>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, String>! = nil
    let viewModel = ProfileViewModel(profileUsecase: ProfileUsecase(userRepository: UserRepository(userService: LoginJoinService(), profileService: UserProfileService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindTableView()
        configureDataSource()
        setupUI()
    }
    
    func setupUI(){
        profileImage.makeCircleShape()
        editButton.makeCircleShape()
        
        currentSnapshot = NSDiffableDataSourceSnapshot<Section, String>()

        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(list, toSection: .main)
        self.dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    func bindTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 75
//        tableView.rx.modelSelected(String.self)
//                    .subscribe(onNext: { index in
//                        print(index)
//                    }).disposed(by: disposeBag)
    }
    
    func configureDataSource(){
        self.dataSource = UITableViewDiffableDataSource<Section, String>(tableView: tableView){ [weak self] (tableView: UITableView, indexPath: IndexPath, item: String) ->
            UITableViewCell? in
           
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item
            if indexPath.row == 2 { //버전 정보
                cell.accessoryType = .detailDisclosureButton
                cell.accessoryView = nil
            }else {
                cell.accessoryView = self?.versionLabel
            }
            cell.contentConfiguration = content
            return cell
            
        }
    }
    
    private func bindViewModel(){
        let input = ProfileViewModel.Input (viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }, cellDidTap: self.tableView.rx.itemSelected.map { $0.row }, editImageButtonTap: self.editButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)
        self.profileName.text = output.nickname
        
        input.editImageButtonTap
            .bind(onNext: navigateToEditProfile)
            .disposed(by: disposeBag)
        
        input.cellDidTap
            .subscribe(onNext: { [weak self] index in
                self.
            })
        
    }
    

}


extension ProfileViewController {
    func navigateToEditProfile() {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController")
        self.navigationController?.pushViewController(editProfileVC!, animated: true)
    }
    
    func navigateToDetail(index: Int) {
        switch index {
        case 0: //내 북마크
            let bookMarkVC = self.storyboard?.instantiateViewController(withIdentifier: "BookMarkViewController")
            self.navigationController?.pushViewController(bookMarkVC!, animated: true)
        case 1: //알림 허용
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case 3: //로그 아웃
            self.alertWithNoViewController(title: "로그아웃", message: "로그아웃 하시겠습니다?", completion: { response in
                if response == "OK" {
                    self.viewModel.
                }
            })
        default: print("버전 정보 클릭")
        }
    }
}
