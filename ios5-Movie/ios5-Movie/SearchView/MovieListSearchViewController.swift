//
//  MovieListViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/18/24.
//

import UIKit
import SnapKit

class MovieListSearchViewController: UIViewController {
    
    let dummyManager = DummyMovieDataManager()
    private var moviesDataArray: [DummyMovie] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDummyData()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadDummyData() {
        dummyManager.makeMovieData()
        moviesDataArray = dummyManager.getDummyMovieData()
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension MovieListSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieSearchCell.identifier, for: indexPath) as? MovieSearchCell else {
            return UICollectionViewCell()
        }
        
        let movie = moviesDataArray[indexPath.item]
        cell.posterImageView.image = movie.movieImage
        cell.titleLabel.text = movie.movieName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let totalSpacing: CGFloat = (spacing * 2) + (spacing * 2) // 양쪽 여백 + 아이템 사이 간격
        let width = (collectionView.bounds.width - totalSpacing) / 3
        return CGSize(width: width, height: width * 1.5)
    }
}

@available(iOS 17.0, *)
#Preview {
    MovieListSearchViewController()
}
