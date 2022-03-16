//
//  MakeFolderViewController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/11.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown
import PhotosUI

enum MakeFolderError: Error {
    case folderNameCount
    case folderImage
    case folderName
    case folderType
}

class MakeFolderViewController: UIViewController, MakeFolderdelegate {

    var parentFolderId: Int = 0
    
    static let type_dropDown = DropDown()
    
    var viewModel = AllBoxViewModel(folderUseCase: FolderUseCase(repository: FolderRepository(folderService: FolderService())))
    
    var defaultImage = UIImage(systemName: "questionmark.square")
    

    
    func dissMiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func done() {
        
        do {
            try checkingNameValidating()
            try validate()
            //to do server mk folder post
            let userId = UserDefaults.standard.integer(forKey: UserDefaultKey.userID)
            //create folder
            var type: String = ""
            
            if(folderView.folderTypeButton.currentTitle! == "텍스트"){
                type = "PHRASE"
            }else if(folderView.folderTypeButton.currentTitle! == "링크"){
                type = "LINK"
            }
            
            let folderInfo = CreateFolderRequest(folderName: folderView.folderNameTextField.text!, userId: userId, type: type, parentFolderId: parentFolderId, imageFile: (folderView.folderImage.image?.jpeg(.lowest))!)
            print("parentFolderID : \(folderInfo)")
            

            FolderService.shared.createFolder(folder: folderInfo, completion: { (response) in
                if(response == true){
                    self.alertViewController(title: "폴더 생성 완료", message: "폴더가 생성되었습니다.", completion: { response in
                        if(response == "OK"){
                            self.navigationController?.popViewController(animated: true)
                        }
                    } )
                }
            }, errorHandler: { (error) in})
    
            
        } catch {
            var errorMessage: String = ""
            switch error as! MakeFolderError {
            case .folderNameCount:
                errorMessage = "10글자 이내로 폴더 이름을 입력해주세요"
            case .folderImage:
                errorMessage = "이미지를 선택해주세요"
            case .folderName:
                errorMessage = "폴더 이름을 입력해주세요"
            case .folderType:
                errorMessage = "폴더 타입을 선택해주세요"
            }
            self.showAlert(title:  "생성 실패", message: errorMessage, style: .alert)
        }
        
       
    }
    
    func checkingNameValidating() throws {
        guard (folderView.folderNameTextField.text!.count < 10) else {
            throw MakeFolderError.folderNameCount
        }
    }
    
    func validate() throws {
        
        guard (folderView.folderNameTextField.text!) != "" else {
            throw MakeFolderError.folderName
        }
        guard (folderView.folderImage.image != defaultImage) else {
            throw MakeFolderError.folderImage
        }
        
        guard folderView.folderTypeButton.currentTitle != "" else {
            throw MakeFolderError.folderType
        }
    }
    
    func folderType() {
        MakeFolderViewController.type_dropDown.anchorView = folderView.folderTypeButton
        MakeFolderViewController.type_dropDown.show()
    }
    
    
    func tapImageView(){
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    @IBOutlet var folderView: MakeFolder!
    
    func type_dropDownSetting(){
        MakeFolderViewController.type_dropDown.textColor = .white
        MakeFolderViewController.type_dropDown.backgroundColor = #colorLiteral(red: 0.2659958005, green: 0.3394620717, blue: 0.6190373302, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderView.delegate = self
        type_dropDownSetting()
        
        MakeFolderViewController.type_dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            folderView.folderTypeButton.setTitle("\(item)", for: .normal)
            folderView.folderTypeButton.setTitleColor(UIColor.black, for: .normal)
            folderView.folderTypeButton.layer.borderWidth = 1
            folderView.folderTypeButton.layer.borderColor = UIColor.black.cgColor
            folderView.folderTypeButton.backgroundColor = UIColor.clear
            folderView.folderTypeButton.setTitleColor(.white, for: .normal)
            MakeFolderViewController.type_dropDown.clearSelection()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    
}

extension MakeFolderViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [self] (image, error) in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.folderView.folderImage.image = image
                    }
                }
        }
            
        } else { // TODO: Handle empty results or item providernot being able load UIImage
            print("can't load image")
            
        }

    }
}

