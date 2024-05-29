//
//  detailViewController.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/28.
//

import UIKit
import Kingfisher


class detailViewController: UIViewController {
    var hotelInfo: Hotel?
    
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var vicinityLabel: UILabel!
    @IBOutlet weak var landscapeCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var starImageViews: [UIImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoDisplay()
        navigationItem.title = "詳細資訊"
        nameLabel.text = hotelInfo?.name
        vicinityLabel.text = hotelInfo?.vicinity
        showStars(count: hotelInfo!.star)
        landscapeCountLabel.text = "景觀圖 (\(String(describing: hotelInfo!.landscape.count)))"
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func photoDisplay(){
        if let imageUrl = URL(string: hotelInfo!.photo) {
            imageViewPhoto.kf.setImage(with: imageUrl)
        }
    }
    
    func showStars(count: Int) {
        for (index, imageView) in starImageViews.enumerated() {
            if index < count {
                imageView.image = UIImage(systemName: "star.fill")
            } else {
                imageView.image = UIImage(systemName: "star")
            }
        }
    }
}


extension detailViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hotelInfo!.landscape.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "landscapeID", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        if let imageUrl = URL(string: hotelInfo!.landscape[indexPath.row]) {
            imageView.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let SliderVC = storyboard.instantiateViewController(withIdentifier: "SliderViewController") as? SliderViewController {
            SliderVC.landscape = hotelInfo!.landscape
            SliderVC.indexRow = indexPath.row
            self.navigationController?.pushViewController(SliderVC, animated: false)
        }
    }
}

extension detailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 80)
    }
    
}
