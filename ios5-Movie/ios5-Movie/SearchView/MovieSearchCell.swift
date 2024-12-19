//
//  MovieSearchTableViewCell.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/18/24.
//

import UIKit
import SnapKit

class MovieSearchCell: UICollectionViewCell {
    static let identifier = "MovieSearchCell"
    
    private var imageURL: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = nil
        imageURL = nil
    }
    
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        
        if let posterPath = movie.posterPath {
            let imageURL = MovieImage.movieImageURL(size: 500, posterPath: posterPath)
            self.imageURL = imageURL
            
            guard let url = URL(string: imageURL) else { return }
            
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                guard let data = try? Data(contentsOf: url) else { return }
    
                DispatchQueue.main.async {
                    self.posterImageView.image = UIImage(data: data)
                }
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 영화 포스터 이미지뷰
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // 영화 제목 레이블
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        
        return label
    }()
    
    private func setupUI() {
        
        [posterImageView, titleLabel].forEach { contentView.addSubview($0)}
        
        // 오토레이아웃 설정
        posterImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5) // 3:2 비율
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(1)
            $0.left.right.equalToSuperview()
        }
    }
}
