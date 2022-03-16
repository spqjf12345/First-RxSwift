//
//  FindPWViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class FindPWViewController: UIViewController {
    
    @IBOutlet weak var IDTextField: UITextField!
    @IBOutlet weak var idCheckButton: UIButton!
    @IBOutlet weak var inValidIDText: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var sendTextLabel: UILabel!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var authenTextField: UITextField!
    
    @IBOutlet weak var reAuthenText: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var authenCodeButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    private var passwordTextField: UITextField = {
        var textfield = UITextField()
        return textfield
    }()
    
    var disposeBag = DisposeBag()
    
    var viewModel = FindPWViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    

}

private extension FindPWViewController {
    func bindViewModel(){
        
        let input = FindPWViewModel.Input (
            backButton: self.backButton.rx.tap.asObservable(),
            idTextfield : self.IDTextField.rx.text.orEmpty.asObservable(),
            checkIDButton : self.idCheckButton.rx.tap.asObservable(),
            phoneNumberTextfield : self.phoneNumberTextField.rx.text.orEmpty.asObservable(),
            sendMessageButton : self.sendMessageButton.rx.tap.asObservable(),
            authenTextfield : self.authenTextField.rx.text.orEmpty.asObservable(),
            authenButton : self.authenCodeButton.rx.tap.asObservable(),
            goToLoginButton: self.goToLoginButton.rx.tap.asObservable(),
            passwordTextfield: self.passwordTextField.rx.text.orEmpty.asObservable()
        )
        
        input.backButton.subscribe(onNext : {
//            self.steps.accept(AllStep.back)
        }).disposed(by: disposeBag)
        
        input.goToLoginButton.subscribe(onNext: {
//            self.steps.accept(AllStep.popToLogin)
        }).disposed(by: disposeBag)
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        output.inValidIDMessage.subscribe(onNext : { bool in
            if(bool == true){
                self.inValidIDText.isHidden = false
            }
        }).disposed(by: disposeBag)
        
        output.sendMessage.filter { $0 == true }
        .subscribe(onNext : { _ in
                self.sendTextLabel.text = "인증번호를 전송했습니다."
            }).disposed(by: disposeBag)
        
        output.sendAuthenMessage
            .subscribe(onNext: { message in
                self.reAuthenText.text = message
            }).disposed(by: disposeBag)
        
        // Bind output
        output.errorMessage
            .observe(on: MainScheduler.instance)
           .bind(onNext: showAlert)
           .disposed(by: disposeBag)
        
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}

    
