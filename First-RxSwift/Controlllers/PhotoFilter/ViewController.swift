//
//  ViewController.swift
//  First-RxSwift
//
//  Created by 조소정 on 2021/10/29.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let naVC = segue.destination as? UINavigationController, let photosVC = naVC.viewControllers.first as? PhotosCollectionViewController else { return }
        
        photosVC.selectedPhoto.subscribe(onNext: { photo in
            DispatchQueue.main.async {
                self.updateUI(with: photo)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
    @IBAction func applyFilterButtonPressed(){
        guard let sourceImage = self.photoImageView.image else { return }
        FilterService().applyFilter(to: sourceImage).subscribe(onNext: { filterdImage in
            DispatchQueue.main.async {
                self.photoImageView.image = filterdImage
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image: UIImage) {
        self.photoImageView.image = image
    }


}

