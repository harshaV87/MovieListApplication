//
//  Properties .swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation

class Properties {
    
    // API End points
    
    static let NowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?language=en-US&page=undefined&api_key=55957fcf3ba81b137f8fc01ac5a31fb5"
    static let ListDetailURL = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page="
    static let MovieDetailsURL = "https://api.themoviedb.org/3/movie/%7BMOVIE_ID%7D?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
    
    static func changingPageNumber(pageNo: Int) -> String {
        
        let ListDetailURLOut = "https://api.themoviedb.org/3/movie/popular?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US&page=\(pageNo)"
        
        return ListDetailURLOut
        
    }
    
    static func gettingMovieDetails(movieID: Int) -> String {
        
         let MovieDetailsURLOut = "https://api.themoviedb.org/3/movie/\(movieID)?api_key=55957fcf3ba81b137f8fc01ac5a31fb5&language=en-US"
        
        return MovieDetailsURLOut
    }
    
    // cell identifiers
    
    static let tableCellID = "listCell"
    static let collectionCellID = "imageCell"
    static let movieDetailVC = "moviedetail"
}
