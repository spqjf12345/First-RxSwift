//
//  AddGiftViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/02.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI
import RxGesture

class AddGiftViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    private var viewModel = AddGiftViewModel(giftUsecase: GiftUseCase(repository: GiftReposotory(giftService: GiftService())))
    @IBOutlet weak var addNotiView: AddNotiFolderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel(){
        let input = AddGiftViewModel.Input(touchImage: addNotiView.imageView.rx.tapGesture().when(.recognized), deleteButtonTap: addNotiView.dismissButton.rx.tap.asObservable(), giftNameTextField: addNotiView.nameTextField.rx.text.orEmpty.asObservable(), giftDueDatePicker: addNotiView.datePicker.rx.date.map { DateUtil.serverSendDateTimeFormat($0)}.asObservable(), weekButtonTap: addNotiView.weekDayButton.rx.tap.asObservable(), threeButtonTap: addNotiView.threeDayButton.rx.tap.asObservable(), oneButtonTap: addNotiView.oneDayButton.rx.tap.asObservable(), storeButtonTap: addNotiView.doneButton.rx.tap.asObservable())
        
        let output = viewModel.transform(from: input, disposeBag: disposeBag)
        
        addNotiView.weekDayButton.tag = 7
        addNotiView.threeDayButton.tag = 3
        addNotiView.oneDayButton.tag = 1
        
        input.touchImage
            .bind(onNext: tapImageView(_:))
            .disposed(by: disposeBag)

        input.weekButtonTap
            .scan(false) { lastState, newState in !lastState }
            .bind(to: addNotiView.weekDayButton.rx.isSelected)
            .disposed(by: disposeBag)

        input.threeButtonTap
            .scan(false) { (lastState, newValue) in !lastState}
            .bind(to: addNotiView.threeDayButton.rx.isSelected)
            .disposed(by: disposeBag)

        input.oneButtonTap
            .scan(false) { (lastState, newValue) in !lastState}
            .bind(to: addNotiView.oneDayButton.rx.isSelected)
            .disposed(by: disposeBag)

        output.disMiss
            .bind(onNext: disMiss)
            .disposed(by: disposeBag)
        
        output.errorMessage
            .observe(on: MainScheduler.instance)
           .bind(onNext: showAlert)
           .disposed(by: disposeBag)
       
        output.enableDoneButton
            .bind(onNext: { [weak self] bool in
                if bool { self?.disMiss() }
            }).disposed(by: disposeBag)
        
        let buttons = [addNotiView.weekDayButton, addNotiView.threeDayButton, addNotiView.oneDayButton].map { $0! }
        let selectedButton = Observable.from(
          buttons.map { button in button.rx.tap.map { button } }
        ).merge()
        selectedButton.subscribe(onNext: {_ in
            updateOutput()
        }).disposed(by: disposeBag)
        
        func updateOutput(){
            output.setAlarmDate.accept(buttons.filter { $0.isSelected }.map { $0.tag })
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


}

extension AddGiftViewController {
    private func disMiss(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String){
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default)
        alert.addAction(confirm)
        present(alert, animated: false, completion: nil)
    }
    
    private func tapImageView(_ recog: UITapGestureRecognizer){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
}

extension AddGiftViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true, completion: nil)
            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                    if let image = image as? UIImage {
                        DispatchQueue.main.async {
                            self.viewModel.imageView.accept(image)
                            self.addNotiView.imageView.image = image
                        }
                    }
                    }
            }
    
        }
}
