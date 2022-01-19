//
//  SignUpViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var IDCheckButton: UIButton!
    @IBOutlet weak var IDValidText: UILabel!
    
    @IBOutlet weak var PasswordTextfield: UITextField!
    @IBOutlet weak var passwordGuideText: UILabel!
    
    @IBOutlet weak var rePasswordTextfield: UITextField!
    @IBOutlet weak var PasswordInValidText: UILabel!
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberGuideText: UILabel!
    @IBOutlet weak var authenRequestButton: UIButton!
    
    @IBOutlet weak var authenTextField: UITextField!
    @IBOutlet weak var authenValidText: UILabel!
    @IBOutlet weak var authenOKButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
