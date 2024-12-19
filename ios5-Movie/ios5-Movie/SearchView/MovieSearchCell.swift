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
    
    // 영화 데이터를 전달받을 변수 (속성감시자)
    var movieData: Movie? {
        didSet {
            guard let movie = movieData else { return }
            titleLabel.text = movie.title
            
            // 이미지 path값을 url로
            if let posterPath = movie.posterPath {
                self.imageURL = MovieImage.movieImageURL(size: 200, posterPath: posterPath)
            }
        }
    }
    
    // 변환된 Url 로 load
    private var imageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    
    // 영화 포스터 이미지뷰
    var posterImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    // 영화 제목 레이블
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .boldSystemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위함
        self.posterImageView.image = UIImage(named: "Loading")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // URL로 이미지 로드
    private func loadImage() {
        
        guard let urlString = self.imageURL, let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            // url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }
    
    private func setupUI() {
        
        [posterImageView, titleLabel].forEach { contentView.addSubview($0)}
        
        // 오토레이아웃 설정
        posterImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5) // 3:2 비율
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
}
