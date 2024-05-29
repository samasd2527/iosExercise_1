//
//  SliderViewController.swift
//  iosExercise_1
//
//  Created by 莊善傑 on 2024/5/28.
//

import UIKit
import Kingfisher

class SliderViewController: UIViewController {
    
    var landscape: [String]?
    var indexRow: Int?
    var didScrollToIndexRow = false
    
    @IBOutlet weak var ImageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ImageCollectionView.dataSource = self
        ImageCollectionView.delegate = self
        
        if let indexRow = indexRow, let landscapeCount = landscape?.count {
            navigationItem.title = "\(indexRow + 1)/\(landscapeCount)"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !didScrollToIndexRow, let indexRow = indexRow {
            let indexPath = IndexPath(item: indexRow, section: 0)
            ImageCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            didScrollToIndexRow = true
        }
    }
}

extension SliderViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return landscape!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderImageID", for: indexPath)
        let silderImage = cell.viewWithTag(1) as! UIImageView
        if let imageUrl = URL(string: landscape![indexPath.row]) {
            silderImage.kf.setImage(with: imageUrl)
        }
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if let landscapeCount = landscape?.count {
            navigationItem.title = "\(page + 1)/\(landscapeCount)"
        }
    }
}

extension SliderViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
