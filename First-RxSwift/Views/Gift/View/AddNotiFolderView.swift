//
//  MakeNotiFolderView.swift
//  PrivateRoom
//
//  Created by JoSoJeong on 2021/07/18.
//

import Foundation
import UIKit

class AddNotiFolderView: UIView {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var weekDayButton: UIButton!
    @IBOutlet weak var threeDayButton: UIButton!
    @IBOutlet weak var oneDayButton: UIButton!
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
    
    private func loadView() {
        let view = Bundle.main.loadNibNamed("AddNotiFolderView",owner: self, options: nil)?.first as! UIView
        view.frame = bounds
        addSubview(view)
    }
    
    func UISetting(){
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleToFill
        nameTextField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - 1, width: nameTextField.frame.width / 2 + 10, height: 1)
        border.backgroundColor = UIColor.white.cgColor
        nameTextField.layer.addSublayer((border))
        nameTextField.textColor = UIColor.white
    }
}
