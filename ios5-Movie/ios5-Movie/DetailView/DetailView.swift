//
//  DetailView.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
import SnapKit
// MARK: - DetailView UI

final class DetailView: UIScrollView {
    
    private let contentView = UIView()
    
    /// 전달받을 이미지URLString 변수
    var movieImageURL: String? {
        didSet {
            loadImage()
        }
    }
    
    lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let movieNameLable: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    let voteAverageLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let movieIntroduceLable: UILabel = {
        let label = UILabel()
        label.text = "영화소개"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    let movieDescriptionLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    let releaseDateLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    lazy var reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.layer.cornerRadius = 15
        return button
    }()
    
    ///생성자 세팅
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupScrollView()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        // MARK: - 디테일 뷰 이미지 로드
    private func loadImage() {
        guard let imageURL = self.movieImageURL, let url = URL(string: imageURL) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.detailImageView.image = UIImage(data: data)
            }
        }
    }
    
    /// 스크롤 뷰 설정
    private func setupScrollView() {
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = true
    }
    
    // MARK: - 오토레이아웃
    private func configureUI() {
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(self.contentLayoutGuide)
            make.width.equalTo(self.frameLayoutGuide)
        }
        
        [
            detailImageView,
            movieNameLable,
            voteAverageLable,
            movieIntroduceLable,
            movieDescriptionLable,
            releaseDateLable,
            reservationButton
        ].forEach { contentView.addSubview($0) }
        
        detailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(340)
            make.width.equalTo(280)
        }
        
        movieNameLable.snp.makeConstraints { make in
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.top.equalTo(detailImageView.snp.bottom).offset(30)
        }
        
        voteAverageLable.snp.makeConstraints { make in
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.top.equalTo(movieNameLable.snp.bottom).offset(5)
        }
        
        movieIntroduceLable.snp.makeConstraints { make in
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.top.equalTo(voteAverageLable.snp.bottom).offset(20)
        }
        
        movieDescriptionLable.snp.makeConstraints { make in
            make.top.equalTo(movieIntroduceLable.snp.bottom).offset(10)
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.trailing.equalTo(detailImageView.snp.trailing).offset(-5)
        }
        
        releaseDateLable.snp.makeConstraints { make in
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.top.equalTo(movieDescriptionLable.snp.bottom).offset(20)
        }
        
        reservationButton.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLable.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
