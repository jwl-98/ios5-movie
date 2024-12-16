//
//  DetailView.swift
//  ios5-Movie
//
//  Created by Watson22_YJ on 12/16/24.
//

import UIKit
import SnapKit
import SwiftUI
// MARK: - DetailView UI

final class DetailView: UIView {
    
    lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        // imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    let movieNameLable: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    let voteAverageLable: UILabel = {
        let label = UILabel()
        label.text = "0.00"
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    private let movieIntroduceLable: UILabel = {
        let label = UILabel()
        label.text = "영화소개"
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    let movieDescriptionLable: UILabel = {
        let label = UILabel()
        label.text = "죽음의 문턱에서 맹수의 초인적인 힘을 얻고 살아 돌아온 크레이븐이 무자비한 복수의 길을 택하며 거침없는 사냥을 펼치는 액션 블록버스터"
        label.numberOfLines = .max
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    let releaseDateLable: UILabel = {
        let label = UILabel()
        label.text = "출시일"
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    lazy var reservationButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.layer.cornerRadius = 15
        return button
    }()
    
    //MARK: - 생성자 셋팅
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 오토레이아웃
    private func configureUI() {
        [
            detailImageView,
            movieNameLable,
            voteAverageLable,
            movieIntroduceLable,
            movieDescriptionLable,
            releaseDateLable,
            reservationButton
        ].forEach { self.addSubview($0) }
        
        detailImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
            make.width.equalTo(240)
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
            make.top.equalTo(voteAverageLable.snp.bottom).offset(30)
        }
        movieDescriptionLable.snp.makeConstraints { make in
            make.top.equalTo(movieIntroduceLable.snp.bottom).offset(10)
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.trailing.equalTo(detailImageView.snp.trailing).offset(-5)
        }
        releaseDateLable.snp.makeConstraints { make in
            make.leading.equalTo(detailImageView.snp.leading).offset(5)
            make.top.equalTo(movieDescriptionLable.snp.bottom).offset(30)
        }
        reservationButton.snp.makeConstraints { make in
            make.top.equalTo(releaseDateLable.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(90)
        }
    }
}

// MARK: - SwiftUI Preview Extension
extension DetailViewController {
    private struct Preview: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            return DetailViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
    
    func toPreview() -> some View {
        Preview()
    }
}

struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewController().toPreview()
    }
}
