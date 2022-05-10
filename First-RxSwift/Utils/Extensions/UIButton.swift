//
//  UIButton.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/10.
//

import UIKit

extension UIButton {
    func makeCircleShape(){
        self.layer.cornerRadius = 0.5
         * self.bounds.size.width
        self.clipsToBounds = true
    }
}
