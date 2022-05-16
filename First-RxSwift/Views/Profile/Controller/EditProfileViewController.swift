//
//  EditProfileViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

class EditProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var quitButton: UIButton!
    
    private let viewModel = ProfileEditViewModel(profileUsecase: ProfileUsecase(userRepository: UserRepository(userService: LoginJoinService(), profileService: UserProfileService())))
    
    let disposeBag = DisposeBag()
    private var section = 0
//    var dataSource: UITableViewDiffableDataSource<Int, List>! = nil
//    var currentSnapshot: NSDiffableDataSourceSnapshot<Int, List>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        configureDataSource()
    }
    
    func setupUI() {
        editButton.makeCircleShape()
        profileImage.makeCircleShape()
    }
    
    private func bindViewModel() {
        let input = ProfileEditViewModel.Input(editButtonTap: editButton.rx.tap.asObservable(), quiAppTap: quitButton.rx.tap.asObservable())
        let output = viewModel.transform(from: input, disposeBag: viewModel.disposeBag)
        
        viewModel.profileUsecase.imageData
            .asDriver(onErrorJustReturn: Data())
            .drive(onNext: { data in
                self.profileImage.image = UIImage(data: data)
            }).disposed(by: disposeBag)
        
        
    }
    
    func configureDataSource(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
        tableView.register(IDInputTableViewCell.nib(), forCellReuseIdentifier: IDInputTableViewCell.identifier)
        tableView.rowHeight = 75
//        dataSource = UITableViewDiffableDataSource<Int, List>(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
//            var content = cell.defaultContentConfiguration()
//            content.text = item.text
//            if indexPath.row != 2 {
//                cell.accessoryType = .disclosureIndicator
//                cell.accessoryView = nil
//            }else {
//                cell.accessoryView = self.versionLabel
//            }
//            if indexPath.row == 3 {
//                content.textProperties.color = .red
//            }
//            cell.contentConfiguration = content
//            return cell
//
//        }
//        dataSource.defaultRowAnimation = .fade
//        tableView.dataSource = dataSource
//        // 빈 snapshot
//        var snapshot = NSDiffableDataSourceSnapshot<Int, List>()
//        snapshot.appendSections([section])
//        section += 1
//        snapshot.appendItems(list)
//        dataSource.apply(snapshot)

    }


}
