//
//  FolderCollectionViewCell.swift
//  PrivateRoom
//
//  Created by JoSoJeong on 2021/05/15.
//

import UIKit
import RxSwift

class FolderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var view: UIView!
    
    static var identifier = "FolderCollectionViewCell"
    @IBOutlet weak var folderImage: UIImageView!
    @IBOutlet weak var folderType: UILabel!
    @IBOutlet weak var folderName: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var delegate: UIViewController?
    
    var indexPath: IndexPath = []
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FolderCollectionViewCell", bundle: nil)
    }

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///new
    func configure(with folder: Folder) {
        folderName.text = folder.folderName
        folderType.text = folder.type
        folderImage.image =  UIImage(data: folder.imageData!)
    }

}
