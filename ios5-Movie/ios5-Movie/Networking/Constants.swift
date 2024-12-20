//
//  Constants.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import Foundation

// MARK: - API Constants

public enum MovieAPI {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            fatalError("API 키가 설정되지 않았습니다.")
        }
        return key
    }()
    
    static let urlQueryItems: [URLQueryItem] = [
        URLQueryItem(name: "api_key", value: apiKey),
        URLQueryItem(name: "language", value: "ko-KR")
    ]
    enum Path: String {
        case nowPlaying = "movie/now_playing"
        case upcoming = "movie/upcoming"
        case popular = "movie/popular"
        case search = "search/movie"
        case topRated = "movie/top_rated"
    }
}

/// 이미지 URL
struct MovieImage {
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static func movieImageURL(size: Int, posterPath: String) -> String {
        return "\(imageBaseURL)w\(size)\(posterPath)"
    }
}

