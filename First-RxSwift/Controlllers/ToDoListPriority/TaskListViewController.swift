//
//  TaskListViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/13.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    
    

    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTask = [Task]()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let naVC = segue.destination as? UINavigationController, let addVC = naVC.viewControllers.first as? AddTaskViewController else  {
            fatalError("no view controllers")
        }
        addVC.taskSubkectObservable.subscribe(onNext: { [unowned self] task in
            print(task)
            let priority = Priority(rawValue: self.segControl.selectedSegmentIndex - 1)
            
            var exstingTasks = self.tasks.value
            exstingTasks.append(task)
            self.tasks.accept(exstingTasks)
            
            self.filterTasks(by: priority)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func priorityValueChanged(segmetedControl: UISegmentedControl){
        let priority = Priority(rawValue: self.segControl.selectedSegmentIndex - 1)
        print(priority)
        filterTasks(by: priority)
    }
    
    private func updateTableview(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func filterTasks(by priority: Priority?) {
        
        if priority == nil {
            self.filteredTask = self.tasks.value
            self.updateTableview()
        } else {
            
            self.tasks.map { tasks in
                return tasks.filter { $0.priority == priority! }
                }.subscribe(onNext: { [weak self] tasks in
                    self?.filteredTask = tasks
                    self?.updateTableview()
                }).disposed(by: disposeBag)
            
        }
        
    }

}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = self.filteredTask[indexPath.row].title
        return cell
    }

}
