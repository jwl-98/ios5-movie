//
// MovieCell.swift
// ios5-Movie
//
// Created by 진욱의 Macintosh on 12/13/24.
//
import UIKit
class MovieCell: UICollectionViewCell {
  static let identifier = "MovieCell"
  private let rankLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    label.textColor = .white
    label.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    label.textAlignment = .center
    label.layer.cornerRadius = 12
    label.clipsToBounds = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 1
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(rankLabel)
    NSLayoutConstraint.activate([
      // 순위 라벨 제약 조건
      rankLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      rankLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      rankLabel.widthAnchor.constraint(equalToConstant: 24),
      rankLabel.heightAnchor.constraint(equalToConstant: 24),
      // 이미지뷰 제약 조건
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
      // 타이틀 라벨 제약 조건
      titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - Configure Method
  func configure(with title: String, rank: Int?, showRank: Bool = true) {
    imageView.image = UIImage(named: title) // 이미지 설정
    titleLabel.text = title // 영화 제목 설정
    if showRank, let rank = rank {
      rankLabel.isHidden = false
      rankLabel.text = "\(rank)"
    } else {
      rankLabel.isHidden = true
    }
  }
}
