//
//  Constants.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import Foundation

// URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=1a7f4bd945e56750ef4ce701f48834dc&language=ko-KR&page=1"
// MARK: - API Constants

public enum MovieAPI {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "1a7f4bd945e56750ef4ce701f48834dc"
    
    static let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "language", value: "ko-KR")
    ]
    enum Path: String {
        case nowPlaying = "movie/now_playing"
        case upcoming = "movie/upcoming"
        case popular = "movie/popular"
        case search = "search/movie"
        case topRated = "movie/top_rated" // 추가된 부분
    }
}

/// 이미지 URL
struct MovieImage {
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static func movieImageURL(size: Int, posterPath: String) -> String {
        return "\(imageBaseURL)w\(size)\(posterPath)"
    }
}
/*
 // 사용예시, 셀에서 사용 사이즈 최소 200~500
 // prepareForeReuse ⭐️, 이미지 URL 을 받을 변수 생성 (didSet)
 
private func loadImage() {
    if let posterPath = movie.posterPath {
        let imageURL = MovieImage.movieImageURL(size: 500, posterPath: posterPath)
        guard let urlString = self.imageURL, let url = URL(string: imageURL) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
 */
 
