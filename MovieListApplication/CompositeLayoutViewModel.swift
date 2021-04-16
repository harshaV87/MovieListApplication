//
//  CompositeLayoutViewModel.swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation

class CompositeViewModel {
        
    // ViewModel for the movieelist
    
    private(set) var webservice : DataAPI!
    
    var movieList : [CResult] = [CResult]()
    
    var allMovies: [ListResult] = [ListResult]()
    
    
    
    init(movies: [CResult]) {
        
        self.movieList = movies
        
    }
    
    init(service: DataAPI) {
        
        self.webservice = service
        
    }
    
    init(allMovies: [ListResult]) {
        
        self.allMovies = allMovies
        
    }
    
    
    
    func getNowPlayingList (completion :@escaping (CompositeViewModel) -> ()) {
        
    webservice.getDataDetail(url: Properties.NowPlayingURL, typeO: CurrentMovies.self) { [weak self] (result, status)  in
            
    switch result {
            
        case .success(let post):

            let postI =  post.results
                    
            self?.movieList = postI

            completion(self!)

                    
        case .failure(let error):

            let error = error.localizedDescription
                
                print(error)

            }
            
          }

    }
    
    
    func getAllMovieList(pageNo: Int, completion :@escaping (CompositeViewModel) -> ()) {
        
        webservice.getDataDetail(url: Properties.changingPageNumber(pageNo: pageNo), typeO: MovieList.self) { [weak self](result, status)  in
            
        switch result {
        
            case .success(let post):

                guard let postI = post.results else {return}
        
                self?.allMovies = postI

                completion(self!)


            case .failure(let error):

                let error = error.localizedDescription

                // for the purpose of simplicity error is printed if the parsing fails
                print(error)
                
                // this error is accesible inside the model

            }
            
          }
        
    }
    
}
