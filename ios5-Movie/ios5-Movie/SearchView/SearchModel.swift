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
    
    // 네트워크 매니저
    private let networkManager = NetworkManager.shared
    
    //api통신후 데이터를 담기위한 배열
    private var movieResultArray: [Movie] = []
    
    func updateSearchResults(with searchText: String?, completion: @escaping ([Movie]) -> Void) {
        //입력값이 존재하지 않는 경우 빈화면으로 표시
         guard let searchText = searchText, !searchText.isEmpty else {
             completion([])
             return
         }
         searchMovies(with: searchText) { movies in
             completion(movies)
         }
     }
    
    func searchMovies(with query: String, completion: @escaping ([Movie]) -> Void) {
        networkManager.fetchSearchData(searchTerm: query) { [weak self] (result: Result<MovieData, AFError>) in
            guard let self = self else { return }
            switch result {
            case .success(let movieData):
                self.movieResultArray = movieData.results
                completion(self.movieResultArray)
            case .failure(let error):
                print("검색실패: \(error.localizedDescription)")
                completion([])
            }
        }
    }
}
