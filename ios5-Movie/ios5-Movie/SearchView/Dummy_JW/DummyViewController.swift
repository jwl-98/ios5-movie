//
//  DummyViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/16/24.
//

import UIKit
import SnapKit

class DummyViewController: UIViewController, UICollectionViewDelegate {
    private let manager = DummyMovieDataManager()
    private var dataArray: [DummyMovie] = []
    var searchButtonAction: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        manager.makeMovieData()
        dataArray = manager.getDummyMovieData()
        navigationController?.navigationBar.isHidden = true
    }
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
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
    
    // MARK: - Setup UI
    private func setupUI() {
        [
            collectionView,
            searchButton
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        searchButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    // MARK: - Setup CollectionView
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    // 검색 버튼 동작
    @objc private func searchButtonTapped() {
        print(#function)
        searchButtonAction?()
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
