//
//  MakeFolderViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/11.
//

import UIKit
import RxFlow
import RxSwift
import RxCocoa

class MakeFolderViewController: UIViewController, Stepper {
    var steps = PublishRelay<Step>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
