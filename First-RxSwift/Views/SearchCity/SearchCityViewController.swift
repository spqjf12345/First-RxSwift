//
//  SearchCityViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/20.
//

import UIKit
import RxCocoa
import RxSwift

class SearchCityViewController: UIViewController {
    var shownCities = [String]() // Data source for UITableView
    let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"]
    @IBOutlet weak var tableView: UITableView!
    let disposeBag = DisposeBag()
    
    let searchController = UISearchController(searchResultsController: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setUpSearchBar()
        setUpNavigationBar()
    }
    
    func setUpSearchBar(){
        searchController.searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance) //0.5초 기다림
            .distinctUntilChanged() // 같은 아이템을 받지 않는기능
            .subscribe(onNext: { t in
                self.shownCities = self.allCities.filter{ $0.hasPrefix(t) }
                self.tableView.reloadData()})
            .disposed(by: disposeBag)
    
    }
    
    func setUpNavigationBar(){
        self.navigationItem.searchController = searchController
    }
    

}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        
        return cell
    }
}
