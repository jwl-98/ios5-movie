//
//  DetailViewController.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
    // MARK: - DetailView Controller

final class DetailViewController: UIViewController {
    
    private let detailView = DetailView()
    
    private let dataManager = DummyMovieDataManager()
    
    private var movie: [DummyMovie] = []
    
    private let networkManager = NetworkManager.shared
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.makeMovieData()
        setupDatas()
        setupButton()
    }

    private func setupDatas() {
        // 셀 선택된 데이터 넘기기
        movie = dataManager.getDummyMovieData()
        detailView.detailImageView.image = movie[0].movieImage
        detailView.movieNameLable.text = movie[0].movieName
    }
    
    private func setupButton() {
        detailView.reservationButton.addTarget(self, action: #selector(reservationButtonTapped), for: .touchUpInside)
    }
    
    @objc func reservationButtonTapped() {
       // let VC = ViewController()
       // VC.modalPresentationStyle = .fullScreen
       // self.present(VC, animated: true, completion: nil)
    }
}
