//
//  DummyViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/16/24.
//

import UIKit

class DummyViewController: UIViewController, UICollectionViewDelegate {
    private let manager = DummyMovieDataManager()
    private var dataArray: [DummyMovie] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let width = (UIScreen.main.bounds.width - 60) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DummyCollectionViewCell.self, forCellWithReuseIdentifier: "DummyCollectionViewCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        manager.makeMovieData()
        dataArray = manager.getDummyMovieData()
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension DummyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DummyCollectionViewCell", for: indexPath) as? DummyCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let movie = dataArray[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

@available(iOS 17.0, *)
#Preview {
    DummyViewController()
}
