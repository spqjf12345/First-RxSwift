//
//  ViewNotiController.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/05/08.
//

import UIKit
import SnapKit

class ViewNotiController: UIViewController, UIScrollViewDelegate {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.delegate = self
        scrollView.zoomScale = 1.0
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .red
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.scrollView)
            make.height.equalTo(self.scrollView)
            make.width.equalTo(self.scrollView)
        }

    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

}

