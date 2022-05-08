//
//  AddFolder.swift
//  PrivateRoom
//
//  Created by JoSoJeong on 2021/07/13.
//

import Foundation
import UIKit

class AddFolder: UIView {

    @IBOutlet weak var folderNameTextField: UITextField!
    @IBOutlet var folderImage: UIImageView!
    @IBOutlet weak var folderTypeButton: UIButton!
    @IBOutlet weak var disMissButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
        UISetting()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
        UISetting()
    }
    
    func UISetting(){
        folderImage.isUserInteractionEnabled = true
        folderImage.contentMode = .scaleToFill
        folderNameTextField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: folderNameTextField.frame.size.height - 1, width: folderNameTextField.frame.width, height: 1)
        border.backgroundColor = UIColor.white.cgColor
        folderNameTextField.layer.addSublayer((border))
        folderNameTextField.textColor = UIColor.white

    }

    private func loadView() {
        let view = Bundle.main.loadNibNamed("AddFolder",owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
        
    }

    
}
