//
//  SearchModel.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/18/24.
//

import Foundation
import Alamofire
//

class SearchModel {
    private var movies: [Movie] = []
    
    func searchMovies(with query: String, completion: @escaping ([Movie]) -> Void) {
        NetworkManager.shared.fetchSearchData(searchTerm: query) { (result: Result<MovieData, AFError>) in
            switch result {
            case .success(let movieData):
                self.movies = movieData.results
                completion(self.movies)
            case .failure(let error):
                print("검색실패: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
