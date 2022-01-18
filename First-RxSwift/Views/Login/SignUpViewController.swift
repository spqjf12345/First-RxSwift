//
//  SignUpViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/01/18.
//

import Foundation
import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController, View {
    
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
    
    func bind(reactor: SignUpViewReactor) {
        
        //reactor input
        self.IDCheckButton.rx.tap
            .map{ SignUpViewReactor.Action.sameIdCheck }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.authenRequestButton.rx.tap
            .map{ SignUpViewReactor.Action.authenRequest }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.authenOKButton.rx.tap
            .map{ SignUpViewReactor.Action.authenCodeCheck }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.signUpButton.rx.tap
            .map{ SignUpViewReactor.Action.signUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        //reactor output
        reactor.state.map { $0.idValidText }
        .distinctUntilChanged()
        .map{ $0 }
        .subscribe{ text in
            self.IDValidText.text = text
        }.disposed(by: disposeBag)
        
        
    }
}
