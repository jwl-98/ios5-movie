//
//  SearchModel.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/18/24.
//

import Foundation

class SearchModel {
    func getAllMovies(from movieListVC: MovieListSearchViewController) -> [String] {
            return [""]
        }
        // 검색어로 영화 필터링
        func filterMovies(_ movies: [String], with query: String) -> [String] {
            if query.isEmpty {
                return movies
            }
            return movies.filter { movie in
                movie.lowercased().contains(query.lowercased())
            }
        }
}
