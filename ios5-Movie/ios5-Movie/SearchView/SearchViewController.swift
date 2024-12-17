//
//  SearchViewViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    
    override func viewDidLoad() {
        print(#function)
        super.viewDidLoad()
        setupNavBar()
        setupDummyViewController()
        setupSearchController()
        dummyViewController.searchButtonAction = { [weak self] in
            self?.showSearchBar()
        }
    }
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "영화 이름 검색"
        
        return searchController
    }()
    
    
    private let dummyViewController = DummyViewController()
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        navigationController?.navigationBar.isHidden = true
        navigationItem.searchController = nil
    }
    
    private func setupNavBar() {
        self.title = "영화 검색"
        //네비게이션 바 타이틀 크기를 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = nil
        searchController.hidesNavigationBarDuringPresentation = false
        
    }
    private func showSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = true
        navigationController?.navigationBar.isHidden = false
        searchController.searchBar.becomeFirstResponder()
    }
    private func setupDummyViewController() {
        addChild(dummyViewController)
        [
            dummyViewController.view
        ].forEach {view.addSubview($0)}
        dummyViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        dummyViewController.didMove(toParent: self)
    }
}


