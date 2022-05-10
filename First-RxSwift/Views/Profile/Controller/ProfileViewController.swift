//
//  ProfileViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
    }
    
    func setupUI(){
        profileImage.makeCircleShape()
        
    }
    
    private func bindViewModel(){
        
    }
    

}
