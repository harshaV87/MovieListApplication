//
//  MovieListCollectionViewCell.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/16/21.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    // SettingViews
    // Only images are shown
    
    var moviePictures: CResult? {
        
        didSet {
            
            imageViewC.contentMode = .scaleToFill
            
            guard let imagePath = moviePictures?.posterPath else {return}

            let imageIn = "https://image.tmdb.org/t/p/w500\(imagePath)"
            
            ImageService.getImage(from: imageIn) { [weak self](image, imageuRL) in
                
                if imageIn == imageuRL {
                    
                    self?.imageViewC.image = image
                    
                }
            }
        }
    }
    
    
    
    let imageViewC = UIImageView()

        override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
        contentView.addSubview(imageViewC)

        imageViewC.translatesAutoresizingMaskIntoConstraints = false
        imageViewC.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageViewC.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageViewC.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageViewC.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}
