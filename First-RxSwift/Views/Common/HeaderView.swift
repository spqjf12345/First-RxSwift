//
//  HeaderView.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class HeaderView: UICollectionReusableView {
    static let reuseIdentifier: String = "HeaderView"
    var sortingText = "이름순"
    var disposeBag = DisposeBag()
    
    lazy var folderCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.darkGray
        label.text = "text"
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
        self.addSubview(sortingButton)
        self.backgroundColor = .blue
        folderCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }
        
        sortingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-24)
        }

        
    }
    
    func updateFolderCount(count: Int){
        folderCountLabel.text = "\(count)개의 폴더"
    }
   
    
}
