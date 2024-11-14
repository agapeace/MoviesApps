//
//  MovieCollectionViewCell.swift
//  MoviesApp
//
//  Created by Damir Agadilov  on 13.11.2024.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"
    
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "flag")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .black)
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    func configureLabels(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = movie.year
        movieImageView.image = movie.movieImage
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyShadows()
        setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyShadows() {
        backgroundColor = .white
        contentView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9725490196, blue: 0.9803921569, alpha: 1)
    
        contentView.layer.cornerRadius = 15
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 2
    }
    
    private func setupViews() {
        
        setupMovieImageView()
        setupStackView()
        
    }
    
    private func setupMovieImageView() {
        contentView.addSubview(movieImageView)
        
        movieImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(250)
            make.width.equalTo(250)
        }
    }
    
    private func setupStackView() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        
        }
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
    }
    

}
