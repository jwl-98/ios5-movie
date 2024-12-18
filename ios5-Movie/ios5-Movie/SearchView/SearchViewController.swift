//
//  SearchViewViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    private let searchModel = SearchModel()
    private var MoviesName: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavBar()
        setupSearchController()
        
    }
    //메인화면 객체 설정
    private let searchMovieListVC: MovieListSearchViewController = {
        let vc = MovieListSearchViewController()
        
        return vc
    }()
    
    //네비게이션 바 설정
    private func setupNavBar() {
        self.title = "영화 검색"
        //네비게이션 바 타이틀 크기를 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    //서치 컨트롤러 기본 설정
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "영화 이름 검색"
        
        return searchController
    }()
    
    //서치바 델리게이트 설정
    private func setupSearchController() {
        //취소버튼 동작을 위한 델리게이트
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    //서치바내 취소버튼 눌리면 실행되는 동작 (navigationBar를 숨김)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("취소버튼 눌림")
    }
    
    private func setupUI() {
        addChild(searchMovieListVC)
        view.addSubview(searchMovieListVC.view)
        searchMovieListVC.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchMovieListVC.didMove(toParent: self)
    }
}

extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredMovies = searchModel.filterMovies(MoviesName, with: searchText)

        print("\(searchText)")
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    let searchVC = SearchViewController()
//    let navigationController = UINavigationController(rootViewController: searchVC)
//    return navigationController
//}
