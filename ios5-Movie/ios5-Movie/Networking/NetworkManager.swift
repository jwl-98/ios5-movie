//
//  NetworkManager.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import Foundation
import Alamofire

//MARK: - Networking
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    /// URL 생성 메서드
    private func makeURL(path: String) -> URL? {
        guard var urlComponents = URLComponents(string: MovieAPI.baseURL + path) else { return nil }
        urlComponents.queryItems = MovieAPI.urlQueryItems
        return urlComponents.url
    }
    
    /// 네트워크 요청 메서드
    func fetchDataByAlamofire<T: Decodable>(path: MovieAPI.Path, completion: @escaping (Result<T, AFError>) -> Void) {
        guard let url = makeURL(path: path.rawValue) else {
            print("잘못된 URL")
            return
        }
        
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// 영화검색 URL 생성 메서드
    private func makeSearchURL(searchTerm: String) -> URL? {
        guard var urlComponents = URLComponents(string: MovieAPI.baseURL + "search/movie") else { return nil }
        urlComponents.queryItems = MovieAPI.urlQueryItems
        urlComponents.queryItems?.append(URLQueryItem(name: "query", value: searchTerm))
        return urlComponents.url
    }
    /// 영화 검색 요청 메서드
    func fetchSearchData<T: Decodable>(searchTerm: String, completion: @escaping (Result<T, AFError>) -> Void) {
        guard let url = makeSearchURL(searchTerm: searchTerm) else {
            print("잘못된 URL")
            return
        }
        
        AF.request(url).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
/*
// 호출방법
NetworkManager.shared.fetchDataByAlamofire(path: .nowPlaying) { [weak self] (result: Result<MovieData, AFError>) in
    guard let self else { return }
    
    switch result {
    case .success(let movieData):
        self.movies = movieData.results
        print("영화 데이터 불러오기 성공!")
        // UI 업데이트
        DispatchQueue.main.async {
            // 테이블 뷰 리로드
        }
    case .failure(let error):
        print("영화 데이터 불러오기 실패: \(error.localizedDescription)")
    }
}
 */
