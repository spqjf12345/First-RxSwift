//
//  MainViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxFlow

class MainViewController: UIViewController {
    var steps = PublishRelay<Step>()
    @IBOutlet weak var allVC: UIButton!
    @IBOutlet weak var textVC: UIButton!
    @IBOutlet weak var linkVC: UIButton!
    @IBOutlet weak var giftVC: UIButton!
    @IBOutlet weak var calendarVC: UIButton!
    @IBOutlet weak var profileVC: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

}
