//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Damir Agadilov  on 14.11.2024.
//

import UIKit
import SnapKit

class MovieTableViewCell: UITableViewCell {

    static let identifier = "MovieTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Default Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    func configureLabel(text: String) {
        nameLabel.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
