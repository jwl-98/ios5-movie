//
//  Constants.swift
//  ios5-Movie
//
//  Created by t2023-m0033 on 12/16/24.
//

import Foundation

// URL = "https://api.themoviedb.org/3/movie/now_playing?api_key=1a7f4bd945e56750ef4ce701f48834dc&language=ko-KR&page=1"
// MARK: - API Constants

public enum MovieAPI {
    static let baseURL = "https://api.themoviedb.org/3/movie"
    static let apiKey = "1a7f4bd945e56750ef4ce701f48834dc"
    
    static let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "language", value: "ko-KR"),
        URLQueryItem(name: "page", value: "1")
    ]
    
    enum Path: String {
        case nowPlaying = "/now_playing"
        case upcoming = "/upcoming"
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
 // 사용예시
 if let posterPath = movie.posterPath {
 let imageURL = Images.movieImageURL(size: 500, posterPath: posterPath)
 if let url = URL(string: imageURL) {
 DispatchQueue.global().async {
 if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
 DispatchQueue.main.async {
 cell.imageView.image = image
 }
 }
 }
 }
 }
 */
