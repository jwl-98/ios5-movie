//
// MovieListViewController.swift
// ios5-Movie
//
// Created by 진욱의 Macintosh on 12/13/24.
//

import UIKit
class MovieListViewController: UIViewController {
  // MARK: - Properties
  private let sectionTitles = ["Top Rated", "Now Playing", "Upcoming", "Trending"] // 섹션 제목
  private let topRatedMovies = ["라팔마", "베놈라스트댄스", "완벽한 우리집으로", "헤레틱"]
  private let nowPlayingMovies = ["데드풀과 울버린", "레드원", "시크릿레벨", "크레이븐 더 헌터"]
  private let upcomingMovies = ["라팔마", "베놈라스트댄스", "완벽한 우리집으로", "헤레틱"]
  private let trendingMovies = ["데드풀과 울버린", "레드원", "시크릿레벨", "크레이븐 더 헌터"]
  private let segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: ["현재상영영화", "영화 검색", "마이페이지"])
    control.selectedSegmentIndex = 0
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()
  private let collectionView: UICollectionView = {
    let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
      return MovieListViewController.createSectionLayout()
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
  }
  private func setupUI() {
    view.backgroundColor = .white
    view.addSubview(segmentedControl)
    view.addSubview(collectionView)
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      segmentedControl.heightAnchor.constraint(equalToConstant: 40),
      collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
      collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.alwaysBounceVertical = true // 전체 스크롤을 세로로 설정
    collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.identifier)
    collectionView.register(
      SectionHeaderView.self,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: SectionHeaderView.identifier
    )
  }
  private static func createSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(150), heightDimension: .absolute(220))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
    let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(1), heightDimension: .absolute(220))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous // 섹션은 좌우 스크롤
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [header]
    return section
  }
}
// MARK: - UICollectionViewDataSource
extension MovieListViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 4 // 섹션 4개: Top Rated, Now Playing, Upcoming, Trending
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch section {
    case 0: return topRatedMovies.count
    case 1: return nowPlayingMovies.count
    case 2: return upcomingMovies.count
    case 3: return trendingMovies.count
    default: return 0
    }
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
      return UICollectionViewCell()
    }
    let movieName: String
    let rank: Int?
    switch indexPath.section {
    case 0: // Top Rated
      movieName = topRatedMovies[indexPath.item]
      rank = indexPath.item + 1
      cell.configure(with: movieName, rank: rank, showRank: true)
    case 1: // Now Playing (순위 제거)
      movieName = nowPlayingMovies[indexPath.item]
      rank = nil
      cell.configure(with: movieName, rank: rank, showRank: false)
    case 2: // Upcoming
      movieName = upcomingMovies[indexPath.item]
      rank = nil
      cell.configure(with: movieName, rank: rank, showRank: false)
    case 3: // Trending
      movieName = trendingMovies[indexPath.item]
      rank = nil
      cell.configure(with: movieName, rank: rank, showRank: false)
    default:
      movieName = ""
      rank = nil
    }
    return cell
  }
  func collectionView(_ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return UICollectionReusableView()
    }
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: SectionHeaderView.identifier,
      for: indexPath
    ) as? SectionHeaderView else {
      return UICollectionReusableView()
    }
    let title = sectionTitles[indexPath.section]
    headerView.configure(with: title)
    return headerView
  }
}
