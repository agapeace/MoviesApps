//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Damir Agadilov  on 14.11.2024.
//
import UIKit
import SnapKit

class MovieDetailsViewController: UIViewController {
    
    private var movie: Movie
    private var detailsArr: [[String: Any]] = []
    
    private let detailsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        return tableView
    }()
    
    private let loaderView: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        return loader
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        detailsTableViewSetUp()
        loaderViewSetUp()
        fetching()
        

    }
    
    private func detailsTableViewSetUp() {
        view.addSubview(detailsTableView)
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        detailsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func loaderViewSetUp() {
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func fetching() {
        Task { [weak self] in
            guard let self = self else { return }
            loaderView.startAnimating()
            self.detailsArr = try await NetworkService.shared.fetchMovieById(movieId: self.movie.imbdId)
            self.detailsTableView.reloadData()
            loaderView.stopAnimating()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MovieDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return detailsArr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionData = detailsArr[section]
            
            guard let firstItem = sectionData.first else {
                return 0
            }
            
            if let value = firstItem.value as? [Any], let isExpanded = value.first as? Bool {
           
                if isExpanded == false {
                    return 1
                } else {
            
                    if let count = value[1] as? [String] {
                        return 1 + count.count
                    }
//                    return value.count > 1 ? (value.count) : 0
                }
            }
            
            return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = MovieTableViewCell.identifier
           let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MovieTableViewCell
           let sectionData = detailsArr[indexPath.section]
           
    
           guard let firstItem = sectionData.first else {
               return cell
           }
           
           if let value = firstItem.value as? [Any], let isExpanded = value.first as? Bool {
    
               if isExpanded == false {
                   let key = firstItem.key
                   let value = value[1]
                   cell.configureLabel(text: "\(key)")
               } else {
                  
                   let key = firstItem.key
                   if indexPath.row == 0 {
                       
                       cell.configureLabel(text: key)
                   } else {
                       
                       if let second = value[1] as? [String] {
                           let item = second[indexPath.row - 1]
                           cell.configureLabel(text: "\(item)")
                       }
                       
//                       let item = value[indexPath.row]
                       
                   }
               }
           }
           
           return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        if var sectionData = detailsArr[indexPath.section].first,
           var value = sectionData.value as? [Any],
           let currentState = value[0] as? Bool {
            
    
            value[0] = !currentState
            
        
            sectionData.value = value
            
  
            detailsArr[indexPath.section] = [sectionData.key: sectionData.value]
            
       
            tableView.reloadSections([indexPath.section], with: .automatic)
        }

    }

    
    
}
