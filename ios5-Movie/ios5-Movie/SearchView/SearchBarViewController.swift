//
//  SearchViewViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit
import SnapKit

class SearchBarViewController: UIViewController, UISearchBarDelegate {
    
    //서치 컨트롤러 기본 설정
    private lazy var searchController: UISearchController = {
        //검색화면을 담당하는 VC
        let searchController = UISearchController(searchResultsController: SearchListViewController())
        searchController.searchBar.placeholder = "영화 이름 검색"
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupSearchController()
        //네비게이션 바 위치 조정
        navigationController?.navigationBar.transform = CGAffineTransform(translationX: 0, y: -10)
    }
    
    //네비게이션 바 설정
    private func setupNavBar() {
        self.title = "영화 검색"
        //네비게이션 바 타이틀 크기를 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    //서치바 델리게이트 설정
    private func setupSearchController() {
        //취소버튼 동작을 위한 델리게이트
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

extension SearchBarViewController {
    //서치바 입력값을 ListVC로 전달
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let resultsController = searchController.searchResultsController as? SearchListViewController {
                    resultsController.updateSearchResults(with: searchText)
                }
        print("\(searchText)")
    }
}
