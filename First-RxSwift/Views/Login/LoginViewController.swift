//
//  LoginViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButton(_ sender: Any) {
    
    }
    
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "signin", sender: nil)
    }
    
    @IBAction func findIDButton(_ sender: Any) {
        performSegue(withIdentifier: "findID", sender: nil)
    }
    
    @IBAction func findPWButton(_ sender: Any) {
        performSegue(withIdentifier: "findPW", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
