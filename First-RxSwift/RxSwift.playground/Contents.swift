import UIKit
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

let numbers = Observable.of(2, 3, 4)

let observable = numbers.startWith(1)
observable.subscribe( onNext : {
    print($0)
}).disposed(by: disposeBag)


//concat

let first = Observable.of(1, 2, 3)
let second = Observable.of(1, 2, 3)





let obserVable = Observable.concat([first, second])
obserVable.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


//merge
let left = PublishSubject<Int>()
let right = PublishSubject<Int>()


let source = Observable.of(left.asObservable(),right.asObservable() )

let observa = source.merge()
observa.subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

left.onNext(5)
left.onNext(3)
right.onNext(2)
right.onNext(1)
right.onNext(100)

//combineLatest
let left1 = PublishSubject<Int>()
let right1 = PublishSubject<Int>()

let observab = Observable.combineLatest(left1, right1, resultSelector: {
    lastLeft, lastRight in
    "\(lastLeft) \(lastRight)"
})

let disposable = observab.subscribe(onNext: { value in
    print(value)
})
left1.onNext(1)
right1.onNext(2)
left1.onNext(3)
left1.onNext(10)
right1.onNext(100)
