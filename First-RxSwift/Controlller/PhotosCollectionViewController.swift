//
//  PhotosCollectionViewController.swift
//  First-RxSwift
//
//  Created by 조소정 on 2021/10/29.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos

class PhotosCollectionViewController: UICollectionViewController {
    
    private var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto: Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()

    }
    
    private func populatePhotos(){
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                guard let self = self else { return }
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image , options: nil)
                
                assets.enumerateObjects { (object, count, stop ) in
                    self.images.append(object)
                }
                self.images.reverse()
                print(self.images)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil, resultHandler: { [weak self] image, info in
            
            guard let info = info else { return }
            
            let isDegradedImage = info["PHImageResultIsDegradedKey"] as! Bool
            if !isDegradedImage {
                if let image = image {
                    self?.selectedPhotoSubject.onNext(image)
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {
             return UICollectionViewCell()
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            DispatchQueue.main.async {
                cell.photoImageView.image = image
            }
        })
        
        return cell
    }
}
