//
//  AddTaskViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/13.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    private let taskSubject = PublishSubject<Tasks>()
    
    var taskSubkectObservable: Observable<Tasks> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func save(){
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex) else { return }
        guard let title = textField.text else { return }
        let  task = Tasks(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
