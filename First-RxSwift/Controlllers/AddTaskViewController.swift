//
//  AddTaskViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/13.
//

import UIKit
import RxSwift

class AddTaskViewController: UIViewController {

    private let taskSubject = PublishSubject<Task>()
    
    var taskSubkectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBAction func save(){
        guard let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex) else { return }
        guard let title = textField.text else { return }
    let  task = Task(title: title, priority: priority)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


}
