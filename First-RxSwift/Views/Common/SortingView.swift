//
//  SortingView.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/16.
//

import Foundation
import UIKit
import RxSwift

class SortingView: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sheetView: UIView!
    @IBOutlet weak var backView: UIView!
    
    let disposeBag = DisposeBag()
    
    var sortList = Observable.of(["이름 순", "생성 순", "최신 순"])
    
    var handlers: [((Any?) -> Void)?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        setUpUI()
        addGesture()
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setUpTableView() {
        tableView.rowHeight = 100
        
        //delegate didselecteRowAt
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SortingTap"), object: indexPath)
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        
    }
    
    func setUpUI() {
        sheetView.clipsToBounds = true
    }
    
    func addGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgrounViewTapped))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func backgrounViewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func bindViewModel(){
        sortList
        .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { index, item, cell in
            var content = cell.defaultContentConfiguration()
            content.text = item
            cell.contentConfiguration = content
        }.disposed(by: disposeBag)
    }
}

//class SortingView: UIAlertController {
//
//    let alertVC = UIViewController.init()
//
//    let tableView: UITableView = {
//        let tableview = UITableView()
//        return tableview
//    }()
//
//    init() {
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sortingCell")
//        setUpUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setUpUI(){
//        let rect = CGRect(x: 0.0, y: 0.0, width: self.alertVC.frame.width, height: 250.0)
//        alertVC.preferredContentSize = rect.size
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.alertVC.view.frame.width, height: 70))
//        let headerLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 300, height: 50))
//
//        let nsHeaderTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: UIFont.Weight.bold),
//                                      NSAttributedString.Key.foregroundColor: UIColor.black]
//
//        headerLabel.text = "정렬하기"
//        headerView.addSubview(headerLabel)
//
//        tableView.tableHeaderView = headerView
//        tableView.tableFooterView = UIView(frame: .zero)
//        tableView.separatorStyle = .none
//        tableView.isScrollEnabled = false
//        alertVC.view.addSubview(tableView)
//        alertVC.view.bringSubviewToFront(tableView)
//        alertVC.view.isUserInteractionEnabled = true
//
//
//        tableView.isUserInteractionEnabled = true
//        tableView.allowsSelection = true
//
//        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alertController.setValue(alertVC, forKey: "contentViewController")
//
//        if UIDevice.current.userInterfaceIdiom == .pad { //디바이스 타입이 iPad일때
//            if let popoverController = alertController.popoverPresentationController {
//
//                popoverController.sourceView = self.view
//                popoverController.sourceRect = CGRect(x: 0.0, y: view.frame.height, width: view.frame.width, height: 250.0)
//                popoverController.permittedArrowDirections = []
//                self.present(alertController, animated: true) { [self] in
//                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//                    alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//                }
//
//            }
//
//        } else {
//            self.present(alertController, animated: true) { [self] in
//            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
//            alertController.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
//            }
//        }
//
//
//    }
//
//    @objc func dismissAlertController()
//    {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//
//}
