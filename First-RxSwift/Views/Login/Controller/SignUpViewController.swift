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
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    
    var disposeBag = DisposeBag()
    
    var viewModel = SignUpViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    
}

private extension SignUpViewController {
    
    func bindViewModel(){
        
        let input = SignUpViewModel.Input (
            backButton : self.backButton.rx.tap.asObservable(),
            idTextfield : self.IDTextField.rx.text.orEmpty.asObservable(),
            checkIDButton: self.IDCheckButton.rx.tap.asObservable(),
            passwordTextfield : self.PasswordTextfield.rx.text.orEmpty.asObservable(),
            rePasswordTextfield : self.rePasswordTextfield.rx.text.orEmpty.asObservable(),
            phoneNumberTextfield : self.phoneNumberTextField.rx.text.orEmpty.asObservable(),
            authenRequestButton : self.authenRequestButton.rx.tap.asObservable(),
            authenTextfield : self.authenTextField.rx.text.orEmpty.asObservable(),
            authenButton: self.authenOKButton.rx.tap.asObservable(),
            signUpButton : self.signUpButton.rx.tap.asObservable()
        )
        
        input.backButton.subscribe(onNext : {
            //self.steps.accept(AllStep.back)
        }).disposed(by: disposeBag)
    
        
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        // Bind output
        output.errorMessage
            .observe(on: MainScheduler.instance)
           .bind(onNext: showAlert)
           .disposed(by: disposeBag)
        
        output.inValidIDMessage
            .subscribe(onNext: { message in
                self.IDValidText.text = message
            }).disposed(by: disposeBag)
        
        output.inValidPWMessage
            .subscribe(onNext: { message in
                self.PasswordInValidText.text = message
            }).disposed(by: disposeBag)
        
        output.sendMessage.filter { $0 == true }
        .subscribe(onNext : { _ in
                self.phoneNumberGuideText.text = "인증번호를 전송했습니다."
            }).disposed(by: disposeBag)
        
        output.inValidAuthenCode
            .subscribe(onNext: { message in
                self.authenValidText.text = message
            }).disposed(by: disposeBag)
        
        output.signUpButtonEnable.asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if(isValid == true){
                    //self.steps.accept(AllStep.login)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
}
