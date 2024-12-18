//
//  DetailViewController.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
// MARK: - DetailView Controller

final class DetailViewController: UIViewController {
    
    let detailView = DetailView()
    
    private var movie: Movie?
    
    var imageUrl: String? {
        didSet {
            
        }
    }
    
    override func loadView() {
        self.view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func configure(with movie: Movie) {
        self.movie = movie // 추가: movie 설정
        
        detailView.movieNameLable.text = movie.title
        detailView.releaseDateLable.text = "출시일: \(movie.releaseDate ?? "N/A")"
        detailView.voteAverageLable.text = "평점: \(movie.voteAverage ?? 0.0)"
        detailView.movieDescriptionLable.text = movie.overview
        
        if let posterPath = movie.posterPath {
            let imageUrl = "https://image.tmdb.org/t/p/w500\(posterPath)"
            loadImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    self.detailView.detailImageView.image = image
                }
            }
        }
    }
    
    private func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
    
    
    private func setupButton() {
        detailView.reservationButton.addTarget(self, action: #selector(reservationButtonTapped), for: .touchUpInside)
    }
    /// 영화 정보 넘기기
    @objc private func reservationButtonTapped() {
        guard let title = movie?.title else { return }
        
        let paymentVC = PaymentViewController()
        paymentVC.movieNameValueLabel.text = title
        navigationController?.pushViewController(paymentVC, animated: true)
    }
}
