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
    
    private var disposeBag = DisposeBag()
    private var alertController = UIAlertController()
    private var tblView = UITableView()
    
    
    private var viewModel = AllBoxViewModel()
    
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
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionOfAnimal>(
        configureCell: { datasource, tableview, indexPath, item in
            let cell = tableview.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
            cell.configure(animal: item)
            return cell
        })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionviewBinding()
    }
    
    func setUpCollectionviewBinding(){
        
    }
    
    
}
