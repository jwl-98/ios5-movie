//
// MovieCell.swift
// ios5-Movie
//
// Created by 진욱의 Macintosh on 12/13/24.

import UIKit

class MovieCell: UICollectionViewCell {
    static let identifier = "MovieCell"
    
    var movieData: Movie? {
        didSet {
            guard let movie = movieData else { return }
            titleLabel.text = movie.title
            
            if let posterPath = movie.posterPath {
                let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
                loadImage(from: imageUrl) { image in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true   // 내용이 뷰 경계를 넘지 않도록 설정
        imageView.layer.cornerRadius = 10  // 네모 끝을 둥글게 (10은 조절 가능)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let  titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
           guard let url = URL(string: urlString) else {
               completion(nil)
               return
           }
           DispatchQueue.global().async {
               guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                   completion(nil)
                   return
               }
               completion(image)
           }
       }
}
