//
// Movie.swift
// ios5-Movie
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
/* Double 반올림하여 스트링 전환방법
 let voteAverage = movie.voteAverage
 String(format: "%.2f", voteAverage)
 */
