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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        populateNews()
    }
    
    private func populateNews(){
        let url = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=cbe61b0ac36141ab8cd720cdc0b2e3b6")!
        
        let resource = Resource<ArticleList>(url: url)
        
        Observable.just(url)
            .flatMap{ url -> Observable<Data> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
            }.map { data -> [Article]? in
                return try? JSONDecoder().decode(ArticleList.self, from: data).articles
            }.subscribe(onNext: { [weak self] articles in
                if let articles = articles {
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            })
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
