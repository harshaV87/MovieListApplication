//
//  MovieListTableViewCell.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/16/21.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    var movieList: ListResult? {
        
        didSet {
            
            // Setting text, image and label aspects
            
            let movieName = movieList?.title ?? ""
            
            let movieRelease = movieList?.release_date ?? ""
        
            // Animation
            
            let voteAverage = (movieList?.vote_average ?? 0.0) * 10
            
            let voteForStrokeAverage = (movieList?.vote_average ?? 0.0) / 10
            
            shapeLayer.strokeEnd = CGFloat(voteForStrokeAverage)
            
            label.string = "\(Int(voteAverage.rounded())) %"
            
            label.alignmentMode = .center
            
            if voteAverage > 50.0 {
                
                shapeLayerColor = UIColor.green
                
            } else {
                
                shapeLayerColor = UIColor.yellow
                
            }
            
            // Text
            
            setAttributedText(movieName: movieName, releaseDate: "\(movieRelease)", movieLength: "-" )
        
            // Image
            guard let imagePath = movieList?.poster_path else {return}

             let imageIn = "https://image.tmdb.org/t/p/w500\(imagePath)"

             print(imageIn)
            
            ImageService.getImage(from: imageIn) { [weak self](image, imageuRL) in
                
                if imageIn == imageuRL {
                    
                    self?.movieImage.image = image
                    
                }
            }
        }
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(topView)
        topView.addSubview(movieImage)
        topView.addSubview(middleLabel)
        topView.addSubview(ratingView)
        
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // movie image
    
    let movieImage: UIImageView = {
        let movieImage = UIImageView()
        movieImage.contentMode = .scaleToFill
        movieImage.clipsToBounds = true
        movieImage.backgroundColor = .red
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieImage.layer.cornerRadius = 10
        
        return movieImage
        
    }()
    
    
    let topView : UIView = {
       let mainSubView = UIView()
        mainSubView.backgroundColor = .black
        mainSubView.translatesAutoresizingMaskIntoConstraints = false
        mainSubView.layer.cornerRadius = 3.0
        mainSubView.layer.masksToBounds = false
        mainSubView.layer.shadowColor = UIColor.blue.cgColor
        mainSubView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mainSubView.layer.shadowOpacity = 0.9
        mainSubView.isUserInteractionEnabled = true
        
        return mainSubView
        
    }()
    
    
    let middleLabel : UILabel = {
        let upLabel = UILabel()
        upLabel.translatesAutoresizingMaskIntoConstraints = false
        upLabel.numberOfLines = 0
        upLabel.textAlignment = .natural
        upLabel.textColor = .white
        upLabel.adjustsFontSizeToFitWidth = false
        upLabel.sizeToFit()
        
        return upLabel
        
    }()
    

   let ratingView : UIView = {
        let upLabel = UIView()
        upLabel.translatesAutoresizingMaskIntoConstraints = false
        upLabel.backgroundColor = .black
        upLabel.sizeToFit()
    
        return upLabel
    
    }()
    

    //MARK: Animation Layer
    
    var label = CATextLayer()
    var shapeLayer = CAShapeLayer()
    var shapeLayerColor = UIColor.white {
        
        didSet {
            
            shapeLayer.strokeColor = shapeLayerColor.cgColor
            
        }
    }
    
    func settingAnimation() {
        
        // Animation to show the percentage votes for a movie in the list
        
        let point = CGPoint.init(x: UIScreen.main.bounds.width / 1.1, y: self.contentView.frame.height)
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 25, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = shapeLayerColor.cgColor
        shapeLayer.fillColor = UIColor.gray.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.position = point
        self.layer.addSublayer(shapeLayer)
        
        //Layer to show the number in the animation
        
        label.frame = CGRect(x: -25, y: -8, width: 40, height: 40)
        label.string = "99"
        label.foregroundColor = UIColor.white.cgColor
        label.font = UIFont(name: "Roboto", size: 21)
        shapeLayer.addSublayer(label)

    }
    

    func setUpView() {
        
        settingAnimation()
    
        topView.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        topView.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        topView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        topView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        //topView.heightAnchor.constraint(equalToConstant: contentView.bounds.height ).isActive = true
        //topView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        
        movieImage.leftAnchor.constraint(equalTo: topView.leftAnchor, constant: 3).isActive = true
        movieImage.topAnchor.constraint(equalTo: topView.topAnchor, constant: 2).isActive = true
        movieImage.bottomAnchor.constraint(equalTo: topView.bottomAnchor, constant: -2).isActive = true
        //profileImageView.rightAnchor.constraint(equalTo: topView.leftAnchor, constant: 20).isActive = true
        movieImage.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.3).isActive = true
        //profileImageView.heightAnchor.constraint(equalToConstant: topView.frame.height).isActive = true
        
        middleLabel.leftAnchor.constraint(equalTo: movieImage.rightAnchor, constant: 3).isActive = true
        middleLabel.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0).isActive = true
        middleLabel.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.5).isActive = true
        middleLabel.bottomAnchor.constraint(equalTo: topView.bottomAnchor).isActive = true
       
        ratingView.leftAnchor.constraint(equalTo: middleLabel.rightAnchor, constant: 0).isActive = true
        ratingView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0).isActive = true
        //ratingView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 0.08).isActive = true
        ratingView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.1).isActive = true
        //ratingView.rightAnchor.constraint(equalTo: topView.rightAnchor, constant: -3).isActive = true
        ratingView.bottomAnchor.constraint(equalTo: topView.safeAreaLayoutGuide.bottomAnchor).isActive = true

    }
    
    
    func setAttributedText(movieName: String, releaseDate: String, movieLength: String) {
        
        // MARK: AttributedString to show various details in a movie
        
        let firstAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: UIColor.black]
        let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 11)]
        let Attributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 9)]
        
        let firstString = NSMutableAttributedString(string: " \(movieName)", attributes: firstAttributes)
        let secondString = NSAttributedString(string: " \n\n \(releaseDate)", attributes: secondAttributes)
        let secoString = NSAttributedString(string: " \n \(movieLength)", attributes: Attributes)
    
        firstString.append(secondString)
        firstString.append(secoString)
        
        middleLabel.attributedText = firstString
        
    }
}
