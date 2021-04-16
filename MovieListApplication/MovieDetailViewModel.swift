//
//  MovieDetailViewModel.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/16/21.
//

import Foundation

class MovieDetailViewModel {
    
    private(set) var webservice : DataAPI!
    
    var movieList : MovieDetails?
    
    var imageURL: String?
    
    init(movieList: MovieDetails) {
        
        self.movieList = movieList
        
    }
    
    init(imageURL: String) {
        
        self.imageURL = imageURL
        
    }
    
    init(service: DataAPI) {
        
        self.webservice = service
        
    }
    
    

    func getAllMovieList(movieIdPassedIn: Int, completion :@escaping (MovieDetailViewModel) -> ()) {
        
        let movieIdLink = Properties.gettingMovieDetails(movieID: movieIdPassedIn)
        
        webservice.getDataDetail(url: movieIdLink, typeO: MovieDetails.self) { (result, status) in
            
        switch result {
            
            case .success(let post):

                guard let movieImagepath = post.poster_path else {return}
            
                let imageIn = "https://image.tmdb.org/t/p/w500\(movieImagepath)"
        
                let movieList = post
                
                self.movieList = movieList
                
                self.imageURL = imageIn
                
                completion(self)

                
            case .failure(let error):

                let error = error.localizedDescription

                // For the purpose of simplicity, error is printed if the parsing fails
                
                // This error is accessible in the view too
                
                print(error)

            }
            
        }
        
    }
    
    
}
