//
//  LoginViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/17.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    private let disposeBag = DisposeBag()
    
    var viewModel = LoginViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
    
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
        self.bindViewModel()
        
        //temp
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        
        self.view.frame.origin.y = -150 // Move view 150 points upward
        }

    @objc func keyboardWillHide(_ sender: Notification) {

        self.view.frame.origin.y = 0 // Move view to original position
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

         self.view.endEditing(true)

        }
    

}

private extension LoginViewController {
    func bindViewModel(){
        print("bindViewModel")
        
        let input = LoginViewModel.Input (
            idTextfield : self.idTextField.rx.text.orEmpty.asObservable(),
            passwordTextfield : self.passwordTextField.rx.text.orEmpty.asObservable(),
            tapLoginButton: self.loginButton.rx.tap.asObservable()
        )

        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        // Bind output
        output.enableLoginInButton
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                self?.loginButton.isEnabled = isValid
                self?.loginButton.backgroundColor = isValid ? .mrPurple : .lightGray
            })
            .disposed(by: self.disposeBag)
        
//       output.enableLoginInButton
//            .observe(on: MainScheduler.instance)
//           .bind(to: loginButton.rx.isEnabled)
//           .disposed(by: disposeBag)
        
       output.errorMessage
            .observe(on: MainScheduler.instance)
           .bind(onNext: showAlert)
           .disposed(by: disposeBag)
        
       output.goToMain
            .observe(on: MainScheduler.instance)
           .bind(onNext: goToMain)
           .disposed(by: disposeBag)
            

        
    }

    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
    
    private func goToMain() {
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "VC")
        let rootNC = UINavigationController(rootViewController: mainVC)
        
        UIApplication.shared.windows.first?.rootViewController = rootNC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}
