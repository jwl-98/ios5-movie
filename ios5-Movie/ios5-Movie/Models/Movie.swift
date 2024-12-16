//
//  Movie.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import Foundation
    // MARK: - MovieData Model

struct MovieData: Codable {
    let resultCount: Int
    let results: [Movie]
}

// MARK: - Result
struct Movie: Codable {
    let overview, posterPath, releaseDate, title: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}
