//
//  FindIDViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class FindIDViewController: UIViewController {
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var authenCodeTextField: UITextField!
    @IBOutlet weak var sendMessageText: UILabel!
    @IBOutlet weak var reAuthenText: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var authenCodeButton: UIButton!
    
    @IBOutlet weak var findPWButton: UIButton!
    @IBOutlet weak var goToLoginButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    var viewModel = FindIDViewModel(loginUseCase: LoginUseCase(repository: UserRepository(userService: LoginJoinService())))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    
    

}

private extension FindIDViewController {
    func bindViewModel(){
        
        let input = FindIDViewModel.Input (
            backButton: self.backButton.rx.tap.asObservable(),
            phoneTextField : self.phoneNumberTextField.rx.text.orEmpty.asObservable(),
            authenRequestButton : self.sendMessageButton.rx.tap.asObservable(),
            authenTextField : self.authenCodeTextField.rx.text.orEmpty.asObservable(),
            authenButton : self.authenCodeButton.rx.tap.asObservable(),
            findPWButton : self.findPWButton.rx.tap.asObservable(),
            goToLoginButton: self.goToLoginButton.rx.tap.asObservable()
        )
    
        input.backButton.subscribe(onNext : {
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
    
        input.findPWButton.subscribe(onNext: {
            self.navigateToFindPW()
        }).disposed(by: disposeBag)
        
        input.goToLoginButton.subscribe(onNext: {
            self.navigationController?.popToRootViewController(animated: true)
        }).disposed(by: disposeBag)
        
        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        // Bind output
        output.errorMessage
            .observe(on: MainScheduler.instance)
           .bind(onNext: showAlert)
           .disposed(by: disposeBag)
        
        output.sendMessage.filter { $0 == true }
        .subscribe(onNext : { _ in
                self.sendMessageText.text = "인증번호를 전송했습니다."
            }).disposed(by: disposeBag)
        
        output.authenValid
            .subscribe(onNext: { message in
                self.reAuthenText.text = message
            }).disposed(by: disposeBag)
    }
    
    private func showAlert(message: String){
        self.alertViewController(title: "알림", message: message, completion: { str in })
    }
}

extension FindIDViewController {
    private func navigateToFindPW() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FindPWViewController") as! FindPWViewController
         self.navigationController?.pushViewController(vc, animated: true)
    }
}
