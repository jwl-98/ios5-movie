//
// SectionHeaderView.swift
// ios5-Movie
//
// Created by 진욱의 Macintosh on 12/13/24.

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let identifier = "SectionHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with title: String) {
        titleLabel.text = title
    }
}










