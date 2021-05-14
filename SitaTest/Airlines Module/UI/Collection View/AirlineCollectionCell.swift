//
//  AirlineCollectionCell.swift
//  SitaTest
//
//  Created by Nikola Nikolic on 13.5.21..
//

import UIKit
import SDWebImage

class AirlineCollectionCell: UICollectionViewCell {
    static let identifier = "AirlineCollectionCell"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    override func prepareForReuse () {
      super.prepareForReuse ()
        imageView.image = nil
    }
    
    func setup(with data: Airline) {
        nameLabel.text = data.name
        
        let favoriteImageName = data.favorite == .yes ? "star.fill" : "star"
        favoriteImageView.image = UIImage(systemName: favoriteImageName)
        
        // NOTE: REAL IMAGE
//        downloadImage(url: data.imageUrl)
        
        //NOTE: IMAGES FOR TESTING
        downloadImage(url: URL.randomImageUrl(with: data.id))
    }
    
    func downloadImage(url: URL?) {
        guard let url = url else {
            return
        }
        
        imageView.sd_setImage(with: url, placeholderImage: nil)
    }
}
