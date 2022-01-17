//
//  WeatherViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2021/11/19.
//

import UIKit
import RxCocoa
import RxSwift

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.rx.controlEvent(.editingDidEndOnExit)
            .asObservable()
            .map { self.nameTextField.text }
            .subscribe(onNext: { city in
                if let city = city {
                    if city.isEmpty {
                        self.displayWeather(nil)
                    }else {
                        self.fetchWeather(by: city)
                    }
                }
            }).disposed(by: disposeBag)
        
//        self.nameTextField.rx.value
//            .subscribe(onNext : { city in
//                if let city = city {
//                    if city.isEmpty {
//                        self.displayWeather(nil)
//                    }else {
//                        self.fetchWeather(by: city)
//                    }
//                }
//
//            }).disposed(by: disposeBag)
    }
    
    private func fetchWeather(by city: String){
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL.urlForWeatherAPI(city: cityEncoded) else {
            return
        }
        
        let resource = Resource<WeatherResult>(url: url)
//        let search = URLRequest.load(resource: resource)
//            .observe(on: MainScheduler.instance)
//            .catchAndReturn(WeatherResult.empty)
//            .asDriver(onErrorJustReturn: WeatherResult.empty)
        
        let search = URLRequest.load(resource: resource)
            .observe(on: MainScheduler.instance)
            .retry(3)
            .catch { error in
                print(error.localizedDescription)
                return Observable.just(WeatherResult.empty)
            }.asDriver(onErrorJustReturn: WeatherResult.empty)
        
        search.map { "\($0.main.temp)‰"}
        .drive(self.label1.rx.text)
        .disposed(by: disposeBag)
        
        search.map { "\($0.main.humidity)‰"}
        .drive(self.label2.rx.text)
        .disposed(by: disposeBag)
        
        
    }
    
    private func displayWeather(_ weather: Weather?){
        if let weather = weather {
            self.label1.text = "\(weather.temp) ‰"
            self.label2.text = "\(weather.humidity) §"
        }else {
            self.label1.text = "🙄"
            self.label2.text = "§"
        }
    }


}

class MethodProgramming {
    func doSomething(){
        print("do something")
    }
    
    func doAnotherThing(){
        print("do another thing")
    }
    
    func execute(tasks:[() -> Void]){
        for task in tasks {
            task()
        }
    }
    
}


