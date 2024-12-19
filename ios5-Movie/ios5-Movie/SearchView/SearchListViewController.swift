//
//  MovieListViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/18/24.
//

import UIKit
import SnapKit

class SearchListViewController: UIViewController,UISearchBarDelegate {
    
    private let searchModel = SearchModel()
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //서치 컨트롤러 기본 설정
    private lazy var searchController: UISearchController = {
        //검색화면을 담당하는 VC
        let searchController = UISearchController(searchResultsController: SearchListViewController())
        searchController.searchBar.placeholder = "영화 이름 검색"
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
        
        return searchController
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 5)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MovieSearchCell.self, forCellWithReuseIdentifier: MovieSearchCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //검색결과 업데이트
    func updateSearchResults(with searchText: String?) {
        searchModel.updateSearchResults(with: searchText) { [weak self] movies in
            self?.movies = movies
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func setupUI() {
        //서치바 규약
        [searchController.searchBar].forEach {
            view.addSubview($0)}
        //컬렉션뷰 규약
        [collectionView].forEach { view.addSubview($0)}
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchController.searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        //검색바가 화면을 덮지 않도록 설정
        definesPresentationContext = true
    }
}

extension SearchListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSearchCell.identifier, for: indexPath) as? MovieSearchCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        cell.setupCell(with: movie) // Movie 타입으로 configure 메서드 호출
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing: CGFloat = (spacing * 2) + (spacing * 2)
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.5)
    }
}

extension SearchListViewController {
    //서치바 입력값
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let resultsController = searchController.searchResultsController as? SearchListViewController {
            resultsController.updateSearchResults(with: searchText)
        }
        print("\(searchText)")
    }
}
