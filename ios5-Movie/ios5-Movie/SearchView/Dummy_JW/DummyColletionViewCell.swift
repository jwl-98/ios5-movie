//
//  DummyTableViewCell.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/16/24.
//

import UIKit
import SnapKit

class DummyCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let movieImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    let movieName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    let movieDescription: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private func configureUI() {
        [movieImage, movieName, movieDescription].forEach {
            contentView.addSubview($0)
        }
        
        movieImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(contentView.snp.width).multipliedBy(0.8)
            $0.height.equalTo(movieImage.snp.width).multipliedBy(1.5)
        }
        
        movieName.snp.makeConstraints {
            $0.top.equalTo(movieImage.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
        
        movieDescription.snp.makeConstraints {
            $0.top.equalTo(movieName.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with movie: DummyMovie) {
        movieImage.image = movie.movieImage
        movieName.text = movie.movieName
        movieDescription.text = movie.movieDescription
    }
}
