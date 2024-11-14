//
//  Movie.swift
//  MovieApp
//
//  Created by Damir Agadilov  on 13.11.2024.
//

import UIKit

// MARK: - Movie
struct MovieResults: Decodable {
    let movieResults: [MovieResponse]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
    }
}

struct MovieResponse: Decodable {
    let title: String
    let year: String
    let imdbId: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case year
        case imdbId = "imdb_id"
    }
}


struct Movie {
    let title: String
    let year: String
    let imbdId: String
    let movieImage: UIImage
    let isExpanded: Bool = false
}

struct MovieImage: Decodable {
    let poster: String?
}

// MARK: - MovieDetails
struct MovieDetails: Decodable {
    
    let title: String
    let description: String
    let year: String
    let imdbRating: String
    let voteCount: String
    let popularity: String
    let genres: [String]
    let stars: [String]
    let language: [String]
    
    enum CodingKeys: String, CodingKey {
        case title, description, year, popularity, genres, stars, language
        case imdbRating = "imdb_rating"
        case voteCount = "vote_count"
    }
    
    func transformToDataSource() -> [[String: [Any]]] {
        let dataSource: [[String: [Any]]] = [
            ["title": [false, self.title]],
            ["description": [false,self.description]],
            ["year": [false, self.year]],
            ["imdbRating": [false,self.imdbRating]],
            ["voteCount": [false, self.voteCount]],
            ["popularity": [false,self.popularity]],
            ["genres": [false, self.genres]],
            ["stars": [false, self.stars]],
            ["language": [false, self.language]]
        ]
        
        return dataSource
    }
}


