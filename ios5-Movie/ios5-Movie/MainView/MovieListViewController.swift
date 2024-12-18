//
//  MovieListViewController.swift
//  ios5-Movie
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    
    // MARK: - Properties
    private var nowPlayingMovies: [Movie] = []
    private var upcomingMovies: [Movie] = []
    private var popularMovies: [Movie] = []
    
    private let sectionTitles = ["Now Playing", "Upcoming", "Popular"]
    
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
        fetchNowPlayingMovies()
        fetchUpcomingMovies()
        fetchPopularMovies()
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
    
    // MARK: - Fetch Movies
    private func fetchNowPlayingMovies() {
        NetworkManager.shared.fetchDataByAlamofire(path: .nowPlaying) { [weak self] (result: Result<MovieData, AFError>) in
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
    
    // MARK: - Fetch Movies
    private func fetchUpcomingMovies() {
        NetworkManager.shared.fetchDataByAlamofire(path: .upcoming) { [weak self] (result: Result<MovieData, AFError>) in
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
    
    // MARK: - Fetch Movies
    private func fetchPopularMovies() {
        NetworkManager.shared.fetchDataByAlamofire(path: .popular) { [weak self] (result: Result<MovieData, AFError>) in
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
        switch sender.selectedSegmentIndex {
        case 0:
            print("현재상영영화 선택됨")// 화면이동 다음 화면으로 갈거야
        case 1:
            print("영화 검색 선택됨")// 화면이동 다음 화면으로 갈거야
        case 2:
            print("마이페이지 선택됨")// 화면이동 다음 화면으로 갈거야
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
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
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
        case 0: cell.movieData = popularMovies[indexPath.item]
        case 1: cell.movieData = nowPlayingMovies[indexPath.item]
        case 2: cell.movieData = upcomingMovies[indexPath.item]
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                           withReuseIdentifier: SectionHeaderView.identifier,
                                                                           for: indexPath) as? SectionHeaderView else {
            return UICollectionReusableView()
        }
        header.configure(with: sectionTitles[indexPath.section])
        return header
    }
}
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie: Movie
        switch indexPath.section {
        case 0:
            movie = popularMovies[indexPath.item]
        case 1:
            movie = nowPlayingMovies[indexPath.item]
        case 2:
            movie = upcomingMovies[indexPath.item]
        default:
            return
        }
        
        // DetailViewController에 영화 데이터 전달
            let detailVC = DetailViewController()
            detailVC.configure(with: movie)
            navigationController?.pushViewController(detailVC, animated: true)
        }
}

