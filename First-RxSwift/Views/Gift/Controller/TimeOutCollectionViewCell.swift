//
//  TimeOutCollectionViewCell.swift
//  PrivateRoom
//
//  Created by JoSoJeong on 2021/07/18.
//

import UIKit
import RxSwift

protocol TimeOutCollectionViewCellDelegate {
    func moreButton(cell: TimeOutCollectionViewCell)
}
class TimeOutCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TimeOutCollectionViewCell"
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var inValidView: UIView!
    @IBOutlet weak var dDayTextLabel: UILabel!
    @IBOutlet weak var titleTextLabel:
        UILabel!
    
    @IBOutlet weak var alarmImageView: UIImageView!
    
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var dateTextLabel: UILabel!
    
    
    @IBAction func moreButton(_ sender: Any) {
        delegate?.moreButton(cell: self)
    }
    var disposeBag = DisposeBag()
    var delegate: TimeOutCollectionViewCellDelegate?
    var indexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.borderColor = UIColor.darkGray.cgColor
        mainView.layer.borderWidth = 1.0
        inValidView.isHidden = true
    }
    
    func configureHeight(width: CGFloat, height: CGFloat){
        alarmImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        mainView.translatesAutoresizingMaskIntoConstraints = false
        mainView.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "TimeOutCollectionViewCell", bundle: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func configure(model: Gift) {
        
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let startTime = Date()
        
        let endTime = DateUtil.parseDateTime(model.deadline)
        let dday = Int(((endTime.timeIntervalSince(startTime)))) / 86400
        
        if(model.isValid == true){ // 비활성화
            inValidView.isHidden = true
            mainView.isUserInteractionEnabled = true
        }else{
            inValidView.isHidden = false
            mainView.isUserInteractionEnabled = false
        }
        
        self.titleTextLabel.text = model.title
        if(model.imageData != nil) {
            
            self.alarmImageView.image = UIImage(data: model.imageData!)
            self.alarmImageView.contentMode = .scaleToFill
        }
        
        let deadLine = DateUtil.parseDateTime(model.deadline)
        
        self.dateTextLabel.text = "~\(deadLine.year)년 \(deadLine.month)월 \(deadLine.day)까지"
        
 
        self.dDayTextLabel.text = "D - \(dday)"
        
    }
    

}
