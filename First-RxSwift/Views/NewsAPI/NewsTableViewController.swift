//
//  NewsTableViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/15.
//

import UIKit
import RxSwift
import RxCocoa

class NewsTableViewController: UITableViewController {

    private var articles = [Article]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        populateNews()
    }
    
    private func populateNews(){
     
        
        URLRequest.load(resource: ArticleList.all)
            .subscribe(onNext: { [weak self] results in
                if results != nil {
                    self?.articles = results.articles
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }).disposed(by: disposeBag)
        }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableviewCell", for: indexPath) as? ArticleTableviewCell else {
            fatalError("ArticleTableviewCell does not exists")
        }
        
        let articleVM = self.articles[indexPath.row]
        cell.title.text = articleVM.title
        cell.descriptions.text = articleVM.description
        return cell
        
    }
    

}
