//
//  MovieDetailViewController.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import UIKit

class MovieDetailViewController: UIViewController {

    // Properties and initialisations
    
    var rootViewModel : MovieDetailViewModel!
    
    var networkService : DataAPI!
    
    var movieIDPassedOver : Int?
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        propertiesAndMethodsToInitialise()
            
    }
    
    // ViewDidLoad setup
    func propertiesAndMethodsToInitialise() {
        
        setupViews()
        self.networkService = DataAPI()
        self.rootViewModel = MovieDetailViewModel(service: networkService)
        getMovieDetailsOn()
        
    }
    
    // MARK: ViewModel functions - getting Data
    
    private func getMovieDetailsOn() {
        
        rootViewModel.getAllMovieList(movieIdPassedIn: movieIDPassedOver ?? 0) { [weak self] (vm) in
            
            self?.rootViewModel = vm
            self?.assigningMovieDetails()
            self?.settingLabelAttributes()
            
        }
        
    }
    
    private func assigningMovieDetails() {
        
        let imageURL = rootViewModel.imageURL
        
        ImageService.getImage(from: imageURL) { [weak self] (image, imageURLString) in
            
            if imageURL == imageURLString {
                
                DispatchQueue.main.async {
                    
                    self?.movieImage.image = image
                }
            }
        }
    }
    
    //MARK: UI Aspects
    
    lazy var movieImage: UIImageView = {
       
        let movieImage = UIImageView()
        movieImage.translatesAutoresizingMaskIntoConstraints = false
        movieImage.backgroundColor = .cyan
        movieImage.isUserInteractionEnabled = true
        movieImage.layer.cornerRadius = 4
        movieImage.clipsToBounds = true
        
        return movieImage
        
    }()

    
    private let movieDetails : UILabel = {
        
        let movieDetails = UILabel()
        movieDetails.translatesAutoresizingMaskIntoConstraints = false
        movieDetails.numberOfLines = 0
        movieDetails.textAlignment = .center
        movieDetails.backgroundColor = .black
        movieDetails.textColor = .white
        movieDetails.adjustsFontSizeToFitWidth = true
        movieDetails.sizeToFit()
        
        return movieDetails
        
    }()
    
    func setupViews() {
        
        view.addSubview(movieImage)
        view.addSubview(movieDetails)
        view.backgroundColor = .black
        
        movieImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        movieImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        movieImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        movieImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true

    
        movieDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5).isActive = true
        movieDetails.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        movieDetails.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        movieDetails.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
    }
    
    // Setting attributed Text
    
    func settingLabelAttributes() {
        
    let style = NSMutableParagraphStyle()
    style.alignment = NSTextAlignment.justified
        
    let firstAttributes: [NSAttributedString.Key: Any] = [.backgroundColor: UIColor.black, NSAttributedString.Key.paragraphStyle: style]
    let secondAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.paragraphStyle: style]
    let thirdAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.paragraphStyle: style]
    let fourthAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.paragraphStyle: style]
        
    let firstString = NSMutableAttributedString(string: "\(rootViewModel.movieList?.original_title ?? "")", attributes: firstAttributes)
    let secondString = NSAttributedString(string: "\n\(rootViewModel.movieList?.release_date ?? "")", attributes: secondAttributes)
    let overviewString = NSAttributedString(string: "\n\nOverview", attributes: thirdAttributes)
    let descriptString = NSAttributedString(string: "\n\(rootViewModel.movieList?.overview ?? "")", attributes: fourthAttributes)
        
    firstString.append(secondString)
    firstString.append(overviewString)
    firstString.append(descriptString)
        
    DispatchQueue.main.async {
            
            self.movieDetails.attributedText = firstString
            
        }
    }
}
