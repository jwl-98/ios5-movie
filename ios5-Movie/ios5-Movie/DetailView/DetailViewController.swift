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
    
    var movieData: Movie? {
        didSet {
            setupMovieDatas()
        }
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    private func setupMovieDatas() {
        guard let movie = self.movieData else { return }
        
        detailView.movieNameLable.text = movie.title
        detailView.releaseDateLable.text = "출시일: \(movie.releaseDate ?? "N/A")"
        detailView.movieDescriptionLable.text = (movie.overview?.isEmpty ?? true) ? "생략" : movie.overview
        
        /// 소수점 셋째자리에서 반올림
        if let voteAverage = movie.voteAverage {
            detailView.voteAverageLable.text = "평점: \(String(format: "%.2f", voteAverage))"
        }
        
        /// DetailView에 URL로 전달
        if let posterPath = movie.posterPath {
            detailView.movieImageURL = MovieImage.movieImageURL(size: 400, posterPath: posterPath)
        }
    }
    
    private func setupButton() {
        detailView.reservationButton.addTarget(self, action: #selector(reservationButtonTapped), for: .touchUpInside)
    }
    
    /// 영화 정보 넘기기 -> PaymentView
    @objc private func reservationButtonTapped() {
        guard let title = movieData?.title else { return }
        
        let paymentVC = PaymentViewController()
        paymentVC.movieNameValueLabel.text = title
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
