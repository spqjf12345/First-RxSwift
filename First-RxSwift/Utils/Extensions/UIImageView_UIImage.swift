//
//  UIImageView.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/10.
//

import UIKit

extension UIImageView {
    func makeCircleShape(){
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.clipsToBounds = true
    }
}
