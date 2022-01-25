//
//  FindIDViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/22.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class FindIDViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authenCodeTextField: UITextField!
    @IBOutlet weak var sendMessageText: UILabel!
    @IBOutlet weak var AuthenSuccessText: UILabel!
    @IBOutlet weak var reAuthenText: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var authenCodeButton: UIButton!
    
    @IBOutlet weak var findPWButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
