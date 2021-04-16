//
//  MovieList .swift
//  MovieListApplication
//
//  Created by Venkata harsha Balla on 4/15/21.
//

import Foundation

// MARK: - Orders
struct MovieList: Decodable, Equatable {
    
    static func == (lhs: MovieList, rhs: MovieList) -> Bool {
        
        return lhs.page == rhs.page
    }
    
    let page: Int?
    let results: [ListResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages
        case totalResults
    }
}

// MARK: - Result
struct ListResult: Decodable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String?
    let video: Bool?
    let vote_average: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath
        case genreIDS
        case id
        case originalLanguage
        case originalTitle
        case overview, popularity
        case poster_path
        case release_date
        case title, video
        case vote_average
        case voteCount
    }
}

