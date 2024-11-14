//
//  NetworkService.swift
//  MovieApp
//
//  Created by Damir Agadilov  on 13.11.2024.
//

import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}

    //Fetching all Movies
    func fetchMovies(page: Int) async throws -> [Movie] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
        
        urlComponents.queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        
        let headers = [
            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
            "Type": "get-trending-movies"
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let parsedData = try JSONDecoder().decode(MovieResults.self, from: data)
            let fetchedMoviesWithImages = try await fetchMovieImage(array: parsedData.movieResults)
                       
            return fetchedMoviesWithImages
        } catch {
            print("Error fetching movies: \(error)")
            throw error 
        }
    }
    
    //Asynchronously fetching each image for the movie
    private func fetchMovieImage(array: [MovieResponse]) async throws -> [Movie] {
        var moviesWithImages = [Movie]()
        
        await withTaskGroup(of: (MovieResponse, UIImage?).self) { taskGroup in
            for movieModel in array {
                taskGroup.addTask { [weak self] in
                    do {
                        // Parse the movie image URL
                        var urlComponents = URLComponents()
                        urlComponents.scheme = "https"
                        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
                        urlComponents.queryItems = [URLQueryItem(name: "movieid", value: "\(movieModel.imdbId)")]
                        
                        let headers = [
                            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
                            "Type": "get-movies-images-by-imdb"
                        ]
                        
                        guard let url = urlComponents.url else {
                            throw URLError(.badURL)
                        }
                        
                        var request = URLRequest(url: url)
                        request.allHTTPHeaderFields = headers
                        request.httpMethod = "GET"
                        
                        let (data, _) = try await URLSession.shared.data(for: request)
                        let parsedData = try JSONDecoder().decode(MovieImage.self, from: data)
                        
                      
                        guard let posterURL = parsedData.poster, let imageURL = URL(string: posterURL) else {
                            return (movieModel, nil)
                        }
                        
                        
                        let (data2, _) = try await URLSession.shared.data(from: imageURL)
                            
                        guard let image = UIImage(data: data2) else {
                            throw URLError(.cannotDecodeContentData)
                        }
                        return (movieModel, image)
                    } catch {
                        print("Error fetching image for \(movieModel.title): \(error)")
                        return (movieModel, nil)
                    }
                }
            }
            
       
            for await (movieModel, image) in taskGroup {
                let movie = Movie(
                    title: movieModel.title,
                    year: movieModel.year,
                    imbdId: movieModel.imdbId,
                    movieImage: image ?? UIImage()
                )
                moviesWithImages.append(movie)
            }
        }
        
        return moviesWithImages
    }
    
    //fetching movie detail info by id
    func fetchMovieById(movieId: String) async throws -> [[String: Any]] {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "movies-tv-shows-database.p.rapidapi.com"
        urlComponents.queryItems = [
            URLQueryItem(name: "movieid", value: "\(movieId)"),
            URLQueryItem(name: "cache_buster", value: UUID().uuidString)
        ]
        
        let headers = [
            "x-rapidapi-key": "67f240ff7fmsh64dfd6cca767880p138221jsnc8d70bdfaee9",
            "Type": "get-movie-details"
        ]
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            let parsedData = try JSONDecoder().decode(MovieDetails.self, from: data)
            return parsedData.transformToDataSource()
        } catch {
            print("Error: \(error)")
            throw error
        }
    }
    
   

}
