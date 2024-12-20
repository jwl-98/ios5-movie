//
//  Movie.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import Foundation

// MARK: - MovieData Model
struct MovieData: Codable {
    let page: Int
    let results: [Movie]
}

// MARK: - Results
struct Movie: Codable {
    let title, enTitle, overview, posterPath, releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case title
        case enTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
