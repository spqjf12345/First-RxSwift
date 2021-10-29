# First-RxSwift
Rxswift를 공부하기 위한 레퍼지토리입니다

# rxSwift

**reactiveX**

- An API for asynchronous programming with observable streams
- a combination of the best ideas from the Observer pattern, the Iterator pattern, and functional programming
    - Benefits
        
        **Composable(조합 가능한)**
        
        - Because Rx is composition’s nickname
        
        **Reusable**
        
        - Because it’s composable
        
        **Declarative**
        
        - Because definitions are immutable and only data changes
        
        **Understandable and concise**
        
        - Raising the level of abstraction and removing transient states
        
        **Stable**
        
        - Because Rx code is thoroughly unit tested
        
        **Less stateful**
        
        - Because you are modeling applications as unidirectional data flows
        
        **Without leaks**
        
        - Because resource management is easy
- **rxCocoa**
    
    An API for IOS UI to react as reactively
    
    ex>
    
    ```
    myButton.rx.tap
        .subscribe(onNext: { print(“tapped”) })
        .disposeBag(self.disposeBag)
    
    ```
    
- **Sequence**
    
    Sequence - array, string, dictionary 과 같이 순차적, 반복적으로 각각의 element에 접근 가능하도록 디자인된 데이터 타입
    
    이러한 Sequence들이 rx에서 observable이 된다.
    
    ```
    let stringSequence = Observable.just("this is string yo")
    let oddSequence = Observable.from([1, 3, 5, 7, 9])
    let dictSequence = Observable.from([1:"Rx",2:"Swift"])
    
    ```
    
    이러한 sequence 들을 subscribe 하여 (for loop와 같이) 사용한다.
    
    **from** - array, dictionary, set 을 observable sequence로 만들고 리턴
    
    **just** : 하나의 element를 observable로 만들고 리턴
    
    from, just를 사용하지 않는 예시
    
    ```
    func myJust<E>(element: E) -> Observable<E> {
        return Observable.create { observer in
            observer.on(.next(element))
            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    myJust(element: "My Just Observable")
        .subscribe { s in
            print(s)
    }
    // -- 출력 --
    // next(My Just Observable)
    // completed
    
    ```
    
    **observable.create**를 통해 observable sequence를 만든다.
    
- **subscribe**
    
    observable의 stream을 관찰하고 구독해서 받는 역할
    
    ```
    Observable<String>.just("test")
    
    .subscribe { event in
    
    switch event {
    
    case .next (let value):
    
    print(value)
    
    case .error(let error):
    
    print(error)
    
    case .completed:
    
    print("complete")
    
    }
    
    }
    
    ```
    
    onNext, onError, onComplete를 구독 받아 print
    
    Observable에서 sequence를 선언 → subscribe를 호출해야 sequence 생성이 이루어짐
    
- **disposable**
    
    처분할 수 있는, 사용 후 버릴 수 있는
    
    ```
    Observable<Int>.interval(1, scheduler: MainScheduler.instance)
      .take(10)
      .subscribe(onNext: { value in
        print(value)
      }, onError: { error in
        print(error)
      }, onCompleted: {
        print("onCompleted")
      }, onDisposed: {
        print("onDisposed")
      })
    
    ```
    
    interval n초마다 정수 타입의 스트림이 emit
    
    take parameter만큼의 스트림을 허용
    
    이 코드를 실행하게 되면 1초마다 정수가 찍히고 10번찍힌 다음 complete와 dispose가 차례대로 출력
    
    자기 할일을 다하고 complete되면서 dispose 즉 할일이 끝났으니 버려지게 된다
    
    ```
    let disposable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
      .take(10)
      .subscribe(onNext: { value in
        print(value)
      }, onError: { error in
        print(error)
      }, onCompleted: {
        print("onCompleted")
      }, onDisposed: {
        print("onDisposed")
      })
    
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        disposable.dispose()
      }
    
    ```
    
    이렇게 하게 되면 3초 뒤에 dispose된다.
    
    disposeBag
    
    구독 받는 observable들이 여러개라면 DisposeBag에 다 넣어줘서 등록된 모든 disposable들이 다 같이 dispose되어 버린다.
    
    ```
    import UIKit
    
    import RxSwift
    
    class CustomViewController: UIViewController {
    
      var disposeBag = DisposeBag()
    
      override func viewDidLoad() {
        super.viewDidLoad()
    
        test()
      }
    
      deinit {
        print(“deinit CustomViewController”)
      }
    
      func test() {
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
          .take(10)
          .subscribe(onNext: { value in
            print(value)
          }, onError: { error in
            print(error)
          }, onCompleted: {
            print(“onCompleted”)
          }, onDisposed: {
            print(“onDisposed”)
          })
          .disposed(by: disposeBag)
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
          UIApplication.shared.keyWindow?.rootViewController = nil
        }
      }
    }
    
    ```
    
    결과 :
    
    0
    
    1
    
    2
    
    denit CustomViewController
    
    onDisposed
    
- **Observable**
    
    관찰 가능한
    
    Observable이라는 객체를 이용해서 하나 또는 연속된 값을 배출할 수 있고
    
    그 배출된 값을 관찰하고 반응한다.
    
    - **Hot, Cold** **Observable**
        - **Hot Observable**
            
            생성 동시에 이벤트 방출 즉 subscribe되는 시점과 상관 없이 옵저버들에게 이벤트를 전송
            
        - **Cold** **Observable**
            
            옵저버가 subscribe되는 시점부터 이벤트 생성하여 방출
            
            Hot Observable이 생성하지 않은 것들은 cold Observable이다.
            
    
    행동 규칙 <next, error, complete>
    
    **next**
    
    next스트림을 통해서 연속된 값을 배출하고
    
    observer는 next 스트림을 관찰 및 구독해서 원하는 행동을 하게 된다
    
    **error**
    
    값을 배출하다 에러가 생기면 error를 배출한 뒤 observaber는 스트림을 멈추게 된다.
    
    **complete**
    
    observaber가 더이상 next를 배출하지 않으면 즉 모든 값을 다 배출하게 되면 complete된다.
    
    스트림 중간에 error가 발생하면 complete되지 않는다.
    
    ex>
    
    ```
    func checkArrayObservable(items: [Int]) -> Observable<Int> {
            //create
          return Observable<Int>.create { observer -> Disposable in
    
            for item in items {
              if item == 0 {
                observer.onError(NSError(domain: "ERROR: value is zero.", code: 0, userInfo: nil))
                break
              }
    
              observer.onNext(item)
    
              sleep(1)
            }
    
            observer.onCompleted()
    
            return Disposables.create()
          }
        }
    
    ```
    
    observer를 파라미터로 받고 Disposables객체를 리턴하는 클로저
    
    observer파라미터는 onNext, onError, onCompleted를 지원한다.
    
    배열 items를 순환하면서 0일때 onError 메소드를 통해 에러를 흘려보내주고
    
    0이 아니면 onNext메소드를 통해 각 엘리멘트를 next로 흘린다.
    
    모든 순환이 끝나면 onCompleted() 메소드를 통해 complete 되었다는 걸 알린다.
    
    Observable을 확인하기 위해선
    
    ```
    checkArrayObservable(items: [4,2,0,5,2])
                .subscribe { event in
                    switch event {
                    case .next(let value):
                        print(value)
                    case .error(let error):
                        print(error)
                    case .complete:
                        print("completed")
                    }
                }
                .disposed(by: self.disposeBag)
    
    ```
    
    subscribe라는 메소드를 사용한다. next, error, completed를 구독 및 관찰하다가 해당 값을 배출하게 되면 값을 print하게 된다.
    
- **Scheduler**
    
    ios에서 multi threading 처리가 필요하면 GCD(dispatch queue)를 사용하지만 rxswift에서는 scheduler를 사용한다. 즉 main queue == main scheduler  // 다른 스레드 == global queue == background scheduler
    
    스케줄링 방식에 따라
    
    Serial Scheduler와 Concurrent Scheduler로 구분
    
    ![https://user-images.githubusercontent.com/50979257/121800177-37859380-cc6b-11eb-9f88-24b04f947f47.png](https://user-images.githubusercontent.com/50979257/121800177-37859380-cc6b-11eb-9f88-24b04f947f47.png)
    
    참고 : [https://iospanda.tistory.com/entry/RxSwift-9-Scheduler](https://iospanda.tistory.com/entry/RxSwift-9-Scheduler)
    
- observeOn
    
    main thread가 아닌 다른 thread(rx가 만들어 놓은 스케줄러)를 사용하겠다는 것
    
    ```
    .observeOn(<Scheduler>.instance)
    
    //or
    
    let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())
    
    .observeOn(backgroundScheduler)
    
    ```
    
- subscribeOn
    
    sequence 생성과 dispose call을 다른 thread(rx가 만들어 놓은 스케줄러)를 사용하겠다는 것
    
    subscriveOn은 subscribe가 호출될때 스케줄러를 지정하는 것
    
- **Subject**
    
    ![https://user-images.githubusercontent.com/50979257/121800176-37859380-cc6b-11eb-8145-dabbad6bdf47.png](https://user-images.githubusercontent.com/50979257/121800176-37859380-cc6b-11eb-8145-dabbad6bdf47.png)
    
    subject는 observable과 observer의 역할을 모두 수행하는 bridge/proxy observable 이다.
    
    그러므로 observable, subject 모두 subscribe할 수 있다. 하지만 observable는 여러 observer 구독 가능한 **multicast** 이고 observable는 하나의 observer만 가능한 **unitcast**이다.
    
    ex> **BehaviorSubject**  예시
    
    하나의 observable 실행이 여러 subscriber에게 공유되면서 같은 값이 프린트 된다.
    
    ```
    // ------ BehaviorSubject/ Subject
        let randomNumGenerator2 = BehaviorSubject(value: 0)
        randomNumGenerator2.onNext(Int.random(in: 0..<100))
    
        randomNumGenerator2.subscribe(onNext: { (element) in
            print("observer subject 1 : \\(element)")
        })
        randomNumGenerator2.subscribe(onNext: { (element) in
            print("observer subject 2 : \\(element)")
        })
    
        --------------------print------------------
    
    observer subject 1 : 92
    observer subject 2 : 92
    
    ```
    
    4가지 종류의 subject가 있다.
    
    - **AsyncSubject**
        
        ![https://user-images.githubusercontent.com/50979257/121800175-36ecfd00-cc6b-11eb-8bdb-2cbfae0ce60d.png](https://user-images.githubusercontent.com/50979257/121800175-36ecfd00-cc6b-11eb-8bdb-2cbfae0ce60d.png)
        
        obsevable이 **complete** 되었을 시 마지막 값을 방출
        
        하지만 observable이 **complete** 되지 않았을 때는 방출하지 않고 원본 Observable과 같이 에러가 발생한다.
        
    - **PublishSubject**
        
        ![https://user-images.githubusercontent.com/50979257/121800173-35bbd000-cc6b-11eb-9209-3cadedd5cd97.png](https://user-images.githubusercontent.com/50979257/121800173-35bbd000-cc6b-11eb-9209-3cadedd5cd97.png)
        
        subscribe된 시점 이후부터 발생한 이벤트 전달, subscribe되기 전의 이벤트는 전달하지 않는다.
        
        에러가 발생하면 에러를 방출한다.
        
    - **BehaviorSubject**
        
        ![https://user-images.githubusercontent.com/50979257/121800171-348aa300-cc6b-11eb-8e93-81ed144430ac.png](https://user-images.githubusercontent.com/50979257/121800171-348aa300-cc6b-11eb-8e93-81ed144430ac.png)
        
        subscribe 시 현재 저장된 값들을 방출한다. 마지막에 값들을 저장하고 싶을때 사용한다.
        
        에러 발생시 마찬가지로 error를 방출한다.
        
    - **ReplaySubject**
        
        언제 observer가 subscribe되든 상관 없이 모든 이벤트들을 방출한다.
        
        ![https://user-images.githubusercontent.com/50979257/121800167-2f2d5880-cc6b-11eb-9c34-9d1e5e92e765.png](https://user-images.githubusercontent.com/50979257/121800167-2f2d5880-cc6b-11eb-9c34-9d1e5e92e765.png)
        

---

- Bind

observable 결합 함수

참고 : [https://brunch.co.kr/@tilltue/6](https://brunch.co.kr/@tilltue/6)

Iterator 패턴

rx.text // observable 속성

.orEmpty // not optional

.subscribe(onNext: { [unowned self] query in

self.showCitiArr = self.allCitiArr.filter { $0.hasPrefix(query) }

self.tableView.reloadData()

})

.addDisposableTo(disposeBag)

---

**참고 영상 및 문헌**

영상

곰튀김님의 rxSwift 4시간에 끝내기 [https://www.youtube.com/watch?v=w5Qmie-GbiA](https://www.youtube.com/watch?v=w5Qmie-GbiA)

문헌

reactiveX docs [http://reactivex.io/languages.html](http://reactivex.io/languages.html)

obserbable marble diagram [https://rxmarbles.com/](https://rxmarbles.com/)
