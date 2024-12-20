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
    private let sectionTitles = ["상영중 영화", "개봉예정 영화", "Popular"]
    
    /// 세그먼트 설정
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["영화 정보", "영화 검색", "회원 정보"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .systemGray6
        control.selectedSegmentTintColor = nil // 선택된 배경색 제거
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal) // 기본 텍스트 색상
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected) // 선택된 텍스트 색상
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    /// 세그먼트 밑에 담을 뷰
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        setupNaviBar()
        setupUI()
        setupCollectionView()
        fetchDatas()
    }
    
    // MARK: - Setup UI
    
    private func setupNaviBar() {
        
        // 네비게이션 바 로고 설정
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        // 네비바 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // Add SegmentedControl
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        
        // Add CollectionView
        view.addSubview(containerView)
        containerView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            // SegmentedControl Layout
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // ContainerView Layout
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
    
    // MARK: - 세그먼트 선택 시 화면전환
    
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        /// 기존 뷰 제거
        containerView.subviews.forEach { $0.removeFromSuperview() }
        
        /// 선택된 세그먼트에 따라 표시할 뷰
        let selectedView: UIView
        
        switch sender.selectedSegmentIndex {
            
            /// 컬렉션뷰
        case 0:
            selectedView = collectionView
            
            /// 영화검색 페이지
        case 1:
            let searchListVC = SearchListViewController()
            addChild(searchListVC)
            selectedView = searchListVC.view
            searchListVC.didMove(toParent: self)
            
            /// 마이페이지
        case 2:
            let userVC = UserPageView()
            addChild(userVC)
            selectedView = userVC.view
            userVC.didMove(toParent: self)
            
        default:
            return
        }
        
        addSubviewToContainer(selectedView)
    }
    
    /// 세그먼트 선택 뷰 추가, 오토레이아웃
    private func addSubviewToContainer(_ view: UIView) {
        containerView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: containerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
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

