//
//  SearchViewViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

    }
    
    private func setupNavBar() {
        let vc = ViewController()
        let searchController = UISearchController(searchResultsController: vc)
        searchController.searchBar.placeholder = "영화 이름 검색"
        self.title = "영화 검색"
        //네비게이션 바 타이틀 크기를 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
       
    }
    
    @objc
    private func searchBarCancelButtonTapped() {
        print(#function)
    }

}
