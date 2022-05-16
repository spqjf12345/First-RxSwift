//
//  ProfileViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import RxSwift
import RxCocoa

struct List: Hashable {
    var text: String
    var id = UUID()
}

class ProfileViewController: UIViewController {
    
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
    
    let list : [List] = [List(text: "내 북마크"), List(text: "알림 허용"), List(text: "버전 정보"), List(text: "로그 아웃")]
    let disposeBag = DisposeBag()
    private var section = 0
    var dataSource: UITableViewDiffableDataSource<Int, List>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, List>! = nil
    let viewModel = ProfileViewModel(profileUsecase: ProfileUsecase(userRepository: UserRepository(userService: LoginJoinService(), profileService: UserProfileService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureDataSource()
        setupUI()
    }
    
    func setupUI(){
        profileImage.makeCircleShape()
        editButton.makeCircleShape()
    }

    func configureDataSource(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.rowHeight = 75
        dataSource = UITableViewDiffableDataSource<Int, List>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = item.text
            if indexPath.row != 2 {
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = nil
            }else {
                cell.accessoryView = self.versionLabel
            }
            if indexPath.row == 3 {
                content.textProperties.color = .red
            }
            cell.contentConfiguration = content
            return cell
            
        }
        dataSource.defaultRowAnimation = .fade
        tableView.dataSource = dataSource
        // 빈 snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Int, List>()
        snapshot.appendSections([section])
        section += 1
        snapshot.appendItems(list)
        dataSource.apply(snapshot)

    }

    private func bindViewModel(){
        let input = ProfileViewModel.Input (viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in }, cellDidTap: self.tableView.rx.itemSelected.asObservable(), editImageButtonTap: self.editButton.rx.tap.asObservable()
        )

        let output = viewModel.transform(from: input, disposeBag: self.disposeBag)

        viewModel.profileUsecase.nickName
                .bind(to: profileName.rx.text)
                .disposed(by: disposeBag)
        
        input.editImageButtonTap
            .bind(onNext: navigateToEditProfile)
            .disposed(by: disposeBag)

        input.cellDidTap
            .subscribe(onNext: { [weak self] indexPath in
                self?.navigateToDetail(index: indexPath)
            }).disposed(by: disposeBag)
        
        viewModel.profileUsecase.imageData
            .asDriver(onErrorJustReturn: Data())
            .drive(onNext: { data in
                self.profileImage.image = UIImage(data: data)
            }).disposed(by: disposeBag)

    }


}


extension ProfileViewController {
    func navigateToEditProfile() {
        let editProfileVC = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController
        self.navigationController?.pushViewController(editProfileVC!, animated: true)
    }

    func navigateToDetail(index: IndexPath) {
        tableView.deselectRow(at: index, animated: true)
        switch index.row {
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
                    self.navigateToLogin()
                }
            })
        default: print("버전 정보 클릭")
        }
    }

    func navigateToLogin(){
        self.viewModel.logout()
        let login = UIStoryboard(name: "Login", bundle: nil)
        guard let loginVC = login.instantiateViewController(withIdentifier: "Login") as? LoginViewController else {
            print("can not find loginNavC")
            return
        }

        let rootNC = UINavigationController(rootViewController: loginVC)
        UIApplication.shared.windows.first?.rootViewController = rootNC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
