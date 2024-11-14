//
//  ViewController.swift
//  MoviesApp
//
//  Created by Damir Agadilov  on 13.11.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private var movieArr: [Movie] = []
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 20
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collection
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    private let viewModel = FirstViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .white
        collectionViewSetUp()
        loaderViewSetUp()
        fetchMovie()
        setupBinders()
    }
    
    private func collectionViewSetUp() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func loaderViewSetUp() {
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetchMovie() {
        loaderView.startAnimating()
        viewModel.fetchAllCountries()
    }
    
    private func setupBinders() {
        viewModel.observableValue.bind { collection in
            self.movieArr = collection
            DispatchQueue.main.async {
                self.loaderView.stopAnimating()
                self.collectionView.reloadData()
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = "MovieCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MovieCollectionViewCell
        let currentMovie = movieArr[indexPath.row]
        cell.configureLabels(movie: currentMovie)
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentMovie = movieArr[indexPath.row]
        viewModel.pushDetailsViewController(navigation: self, currentMovie: currentMovie)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screensize = view.frame.width - 30
        return CGSize(width: screensize, height: 350)
    }
}

