//
//  SearchViewViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchBarDelegate {
    private let dummyViewController = DummyViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupDummyViewController()
        setupSearchController()
        dummyViewController.searchButtonAction = { [weak self] in
            self?.showSearchBar()
        }
    }
    
    //서치 컨트롤러 기본 설정
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "영화 이름 검색"
        
        return searchController
    }()
    
    //서치컨트롤러 델리게이트 설정
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
    }
        
    //네비게이션 바 설정
    private func setupNavBar() {
        self.title = "영화 검색"
        //네비게이션 바 타이틀 크기를 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = nil
    }
    //검색 버튼을 누르면 동작하는 함수 (서치바가 나타남)
    private func showSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.searchController?.isActive = true
        navigationController?.navigationBar.isHidden = false
        searchController.searchBar.becomeFirstResponder()
    }
    //서치바내 취소버튼 눌리면 실행되는 동작 (navigationBar를 숨김)
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        navigationController?.navigationBar.isHidden = true
        navigationItem.searchController = nil
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


