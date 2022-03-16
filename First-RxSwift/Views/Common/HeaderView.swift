//
//  HeaderView.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/16.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = "HeaderView"
    var sortingText = "이름순"
    
    lazy var folderCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        return label
    }()
    
    lazy var sortingButton: UIButton = {
       let button = UIButton()
        let sortingButtonTextAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: UIColor.green, NSAttributedString.Key.kern: 10]
        let sortingButtonText = NSMutableAttributedString(string: "\(sortingText)", attributes: sortingButtonTextAttributes)
        button.setTitle(sortingButtonText.string, for: .normal)
        button.setTitleColor(UIColor.gray, for: .normal)
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(folderCountLabel)
        folderCountLabel.translatesAutoresizingMaskIntoConstraints = false
        folderCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10).isActive = true
        
        
    }
   
    
}
