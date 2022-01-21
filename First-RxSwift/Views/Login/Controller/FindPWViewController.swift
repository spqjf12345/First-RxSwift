//
//  FindPWViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/22.
//

import UIKit

class FindPWViewController: UIViewController {
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var idCheckButton: UIButton!
    @IBOutlet weak var inValidIDText: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var sendTextLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var authenTextField: UITextField!
    
    @IBOutlet weak var reAuthenText: UILabel!
    
    @IBOutlet weak var AuthenSuccess: UILabel!
    @IBOutlet weak var authenCodeButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    private var passwordTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
