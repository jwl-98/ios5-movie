//
//  UserPageView.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/18/24.
//

import UIKit
import SnapKit

class UserPageView: UIViewController {
    
    // MARK: - Properties
    private let userDefaults = UserDefaultsManager.shared
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    private let ticketsSectionLabel: UILabel = {
        let label = UILabel()
        label.text = "My Tickets"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let ticketView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let bookingDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let peopleCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .white
        
        // 저장된 사용자 정보 표시
        if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            emailLabel.text = savedEmail
        }
        
        // 저장된 사용자 이름 표시
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            nameLabel.text = savedName
        } else {
            // 이름이 없을 경우 이메일의 @ 앞부분을 표시
            if let email = emailLabel.text {
                let username = email.components(separatedBy: "@")[0]
                nameLabel.text = username
            }
        }
        
        // Add subviews
        [profileImageView, nameLabel, emailLabel, ticketsSectionLabel,
         ticketView, logoutButton].forEach { view.addSubview($0) }
        
        setupConstraints()
        setupActions()
        
        // 예매 정보 표시
        let bookingInfo = userDefaults.getBookingInfo()
        if let title = bookingInfo.title {
            movieTitleLabel.text = "영화: \(title)"
            bookingDateLabel.text = "날짜: \(bookingInfo.date ?? "") \(bookingInfo.time ?? "")"
            peopleCountLabel.text = "인원: \(bookingInfo.count ?? 0)명"
            
            // 티켓 뷰에 레이블 추가
            ticketView.addSubview(movieTitleLabel)
            ticketView.addSubview(bookingDateLabel)
            ticketView.addSubview(peopleCountLabel)
            
            // 티켓 뷰 내부 레이블 제약조건
            movieTitleLabel.snp.makeConstraints { make in
                make.top.leading.equalToSuperview().offset(15)
            }
            
            bookingDateLabel.snp.makeConstraints { make in
                make.top.equalTo(movieTitleLabel.snp.bottom).offset(10)
                make.leading.equalTo(movieTitleLabel)
            }
            
            peopleCountLabel.snp.makeConstraints { make in
                make.top.equalTo(bookingDateLabel.snp.bottom).offset(10)
                make.leading.equalTo(movieTitleLabel)
            }
        }
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(80)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.top).offset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(nameLabel)
        }
        
        ticketsSectionLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
        }
        
        ticketView.snp.makeConstraints { make in
            make.top.equalTo(ticketsSectionLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupActions() {
        logoutButton.addTarget(self,
                             action: #selector(logoutButtonTapped),
                             for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃",
                                    message: "로그아웃 하시겠습니까?",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            self?.userDefaults.logout()
            
            // 로그인 화면으로 이동
            let loginVC = LoginView()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - SwiftUI Preview
@available(iOS 17.0, *)
#Preview {
    UserPageView()
}
