//
//  MovieListViewController.swift
//  ios5-Movie
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager.shared
    
    // 현재 상영중 영화
    private var nowPlayingMovies: [Movie] = []
    
    // 개봉 예정 영화
    private var upcomingMovies: [Movie] = []
    
    // 인기있는 영화
    private var popularMovies: [Movie] = []
    
    /// 컬렉션 뷰 섹션
    private let sectionTitles = ["Now Playing", "Upcoming", "Popular"]
    
    /// 세그먼트 설정
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["현재상영영화", "영화 검색", "마이페이지"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .systemGray6
        control.selectedSegmentTintColor = nil // 선택된 배경색 제거
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal) // 기본 텍스트 색상
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected) // 선택된 텍스트 색상
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return MovieListViewController.createSectionLayout(sectionIndex: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchDatas()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add SegmentedControl
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        // Add CollectionView
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // SegmentedControl Layout
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // CollectionView Layout
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
        collectionView.register(SectionHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderView.identifier)
    }
    
    // MARK: - Fetch API Datas
    private func fetchDatas() {
        fetchNowPlayingMovies()
        fetchUpcomingMovies()
        fetchPopularMovies()
    }
    
    /// Fetch NowPlaying
    private func fetchNowPlayingMovies() {
        networkManager.fetchDataByAlamofire(path: .nowPlaying) { [weak self] (result: Result<MovieData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let movieData):
                self.nowPlayingMovies = movieData.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch Upcoming
    private func fetchUpcomingMovies() {
        networkManager.fetchDataByAlamofire(path: .upcoming) { [weak self] (result: Result<MovieData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let movieData):
                self.upcomingMovies = movieData.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    /// Fetch Popular
    private func fetchPopularMovies() {
        networkManager.fetchDataByAlamofire(path: .popular) { [weak self] (result: Result<MovieData, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let movieData):
                self.popularMovies = movieData.results
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("데이터 불러오기 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        // 기존 뷰 제거
        view.subviews.filter { $0 !== segmentedControl && $0 !== collectionView }.forEach { $0.removeFromSuperview() }
        
        switch sender.selectedSegmentIndex {
        case 0:
            // 현재상영영화: 기본 콜렉션뷰 표시
            collectionView.isHidden = false
            
        case 1:
            // 영화 검색 화면 표시
            let searchVC = SearchViewController()
            addChild(searchVC)
            view.addSubview(searchVC.view)
            searchVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchVC.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
                searchVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                searchVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                searchVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            searchVC.didMove(toParent: self)
            collectionView.isHidden = true
            
        case 2:
            // 마이페이지(로그인) 화면 표시 이거 마이페이지로 변경하셔야함
            let loginVC = LoginView()
            addChild(loginVC)
            view.addSubview(loginVC.view)
            loginVC.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                loginVC.view.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
                loginVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loginVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
            loginVC.didMove(toParent: self)
            collectionView.isHidden = true
            
        default:
            break
        }
    }
    
    // MARK: - Layout Configuration
    private static func createSectionLayout(sectionIndex: Int) -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .absolute(250))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
}

// MARK: - UICollectionViewDataSource
extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return popularMovies.count
        case 1: return nowPlayingMovies.count
        case 2: return upcomingMovies.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.movieData = popularMovies[indexPath.item]
        case 1:
            cell.movieData = nowPlayingMovies[indexPath.item]
        case 2:
            cell.movieData = upcomingMovies[indexPath.item]
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier,for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        header.configureHeader(with: sectionTitles[indexPath.section])
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = DetailViewController()
        
        switch indexPath.section {
        case 0:
            detailVC.movieData = popularMovies[indexPath.item]
        case 1:
            detailVC.movieData = nowPlayingMovies[indexPath.item]
        case 2:
            detailVC.movieData = upcomingMovies[indexPath.item]
        default:
            return
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

