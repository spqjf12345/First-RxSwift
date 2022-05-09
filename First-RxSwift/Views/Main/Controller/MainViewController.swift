//
//  MainViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/01.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    var nestedViewControllers = [UIViewController]()
    
    private let disposeBag = DisposeBag()
    
 
    @IBOutlet weak var tapStackView: UIStackView!
    
    private lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.delegate = self
        page.dataSource = self
        return page
    }()
    
    
    @IBOutlet weak var allVC: UIButton!
    @IBOutlet weak var textVC: UIButton!
    @IBOutlet weak var linkVC: UIButton!
    @IBOutlet weak var giftVC: UIButton!
    @IBOutlet weak var calendarVC: UIButton!
    @IBOutlet weak var profileVC: UIButton!
    
    @IBAction func profileVC(_ sender: Any) {
        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(profileVC!, animated: true)
       
    }

    var btnLists : [UIButton] = []
        
    var currentIndex : Int = 0 {
        didSet{
            changeBtnColor()
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setBtnList()
        layout()
        bind()
        setupSubView()
        guard let firstVC = nestedViewControllers.first else { return }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
        
    }
    
    func setupSubView(){
        let mainVC = UIStoryboard.init(name: "AllBox", bundle: nil).instantiateViewController(identifier: "AllBoxViewController") as AllBoxViewController
        let textVC = UIStoryboard.init(name: "Phrase", bundle: nil).instantiateViewController(identifier: "TextViewController") as TextViewController
        let linkVC = UIStoryboard.init(name: "Link", bundle: nil).instantiateViewController(identifier: "LinkViewController") as LinkViewController
        let notiVC = UIStoryboard.init(name: "Timeout", bundle: nil).instantiateViewController(identifier: "GiftViewController") as GiftViewController
        let calendarVC = UIStoryboard.init(name: "Calendar", bundle: nil).instantiateViewController(identifier: "CalendarViewController") as CalendarViewController
    
        nestedViewControllers.append(mainVC)
        nestedViewControllers.append(textVC)
        nestedViewControllers.append(linkVC)
        nestedViewControllers.append(notiVC)
        nestedViewControllers.append(calendarVC)
    }
    
    
    private func layout() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)

        NSLayoutConstraint.activate([pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                                     pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                     pageViewController.view.topAnchor.constraint(equalTo: tapStackView.bottomAnchor, constant: 16),
                                     pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        pageViewController.didMove(toParent: self)
    }
    
    private func bind() {
        let tags = Observable.of(0,1,2,3,4,5)
        tags.subscribe(onNext: { [weak self] selectedIndex in
            self?.selectSegmentWith(selectedIndex: selectedIndex)
        }).disposed(by: disposeBag)
    }
    
    private func selectSegmentWith(selectedIndex: Int) {
        guard let currentViewController = pageViewController.viewControllers?.first,
            let index = nestedViewControllers.firstIndex(of: currentViewController),
            index != selectedIndex,
            nestedViewControllers.count > selectedIndex else {
                return
        }

        let selectedViewController = nestedViewControllers[selectedIndex]
        pageViewController.setViewControllers([selectedViewController], direction: .forward, animated: false, completion: nil)
    }
    
    
    
    
    
    func setBtnList() {
        btnLists.append(allVC)
        btnLists.append(textVC)
        btnLists.append(linkVC)
        btnLists.append(giftVC)
        btnLists.append(calendarVC)
        btnLists.append(profileVC)
    }
    
    func changeBtnColor(){

        for (index, element) in btnLists.enumerated(){

            if index == currentIndex {
                element.setTitleColor(UIColor(named: "navy1")!, for: .normal)
            }
            else{
                element.setTitleColor(#colorLiteral(red: 0.09519775957, green: 0.1197544411, blue: 0.2188102901, alpha: 1), for: .normal)
            }

        }

    }
    
    
//    var pageViewController : PageViewController!
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "pageViewController" {
//
//            guard let vc = segue.destination as? PageViewController else {
//                return}
//            pageViewController = vc
//
//            pageViewController.completeHandler = { (result) in
//                self.currentIndex = result
//            }
//
//        }
//
//    }
//
//
//    @IBAction func allVC(_ sender: Any) {
//        pageViewController.setViewcontrollersFromIndex(index: 0)
//    }
//
//    @IBAction func textVC(_ sender: Any) {
//        pageViewController.setViewcontrollersFromIndex(index: 1)
//    }
//
//    @IBAction func linkVC(_ sender: Any) {
//        pageViewController.setViewcontrollersFromIndex(index: 2)
//    }
//
//    @IBAction func giftVC(_ sender: Any) {
//        pageViewController.setViewcontrollersFromIndex(index: 3)
//    }
//
//    @IBAction func calendarVC(_ sender: Any) {
//        pageViewController.setViewcontrollersFromIndex(index: 4)
//    }
//
//    @IBAction func profileVC(_ sender: Any) {
//        let profileVC = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(identifier: "ProfileViewController") as? ProfileViewController
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        self.navigationController?.pushViewController(profileVC!, animated: true)
//
//    }
//
    

}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = nestedViewControllers.firstIndex(of: viewController), index > 0 else { return nil }
        return nestedViewControllers[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = nestedViewControllers.firstIndex(of: viewController), index < nestedViewControllers.count - 1 else { return nil }
        return nestedViewControllers[index + 1]
    }
}

extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = pageViewController.viewControllers?.first,
            let index = nestedViewControllers.firstIndex(of: currentViewController) else {
            return
        }
        self.currentIndex = index
        
        //tabSegmentedControl.selectedSegmentIndex = index
    }
}
