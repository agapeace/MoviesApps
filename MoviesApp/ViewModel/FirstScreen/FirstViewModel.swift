//
//  FirstViewModel.swift
//  MoviesApp
//
//  Created by Damir Agadilov  on 14.11.2024.
//

import UIKit

class FirstViewModel {
    
    var observableValue: ObservableObject<Movie> = ObservableObject(valueArr: [])
    
    func fetchAllCountries() {
        Task { [weak self] in
            guard let self = self else { return }
            self.observableValue.valueArr = try await NetworkService.shared.fetchMovies(page: 1)
        }
    }
    
    func pushDetailsViewController(navigation: UIViewController, currentMovie: Movie) {
        
        let vc = MovieDetailsViewController(movie: currentMovie)
        
        navigation.navigationController?.pushViewController(vc, animated: true)
    }
    
}
