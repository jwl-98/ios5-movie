//
//  UserPageView.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/18/24.
//

import UIKit
import SnapKit

// MARK: - UserPageView
/// 사용자의 프로필과 예매 내역을 보여주는 화면
class UserPageView: UIViewController {
    
    // MARK: - Properties
    /// UserDefaults 매니저 인스턴스
    private let userDefaults = UserDefaultsManager.shared
    
    /// 사용자 프로필 이미지를 표시하는 이미지뷰
    private let profileImageView = UIImageView()
    
    /// 사용자 이름을 표시하는 레이블
    private let nameLabel = UILabel()
    
    /// 사용자 이메일을 표시하는 레이블
    private let emailLabel = UILabel()
    
    /// "My Tickets" 섹션 제목 레이블
    private let ticketsSectionLabel = UILabel()
    
    /// 예매 내역을 담는 컨테이너 뷰
    private let ticketView = UIView()
    
    /// 로그아웃 버튼
    private let logoutButton = UIButton(type: .system)
    
    /// 예매 내역을 표시할 테이블뷰
    private let tableView = UITableView()
    
    /// 예매 내역 데이터를 저장할 배열
    private var bookings: [UserDefaultsManager.BookingInfo] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI Configuration
    /// UI 요소 설정 및 레이아웃 구성
    private func configureUI() {
        setupBasic()
        setupComponents()
        setupConstraints()
    }
    
    /// 기본 설정
    private func setupBasic() {
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// UI 컴포넌트 설정
    private func setupComponents() {
        setupProfileImageView()
        setupLabels()
        setupTicketView()
        setupTableView()
        setupLogoutButton()
        loadUserData()
        
        // 뷰에 컴포넌트 추가
        [profileImageView, nameLabel, emailLabel,
         ticketsSectionLabel, ticketView, logoutButton].forEach {
            view.addSubview($0)
        }
        ticketView.addSubview(tableView)
    }
    
    /// 프로필 이미지뷰 설정
    private func setupProfileImageView() {
        profileImageView.backgroundColor = .systemGray5
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
    }
    
    /// 레이블 설정
    private func setupLabels() {
        nameLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        
        emailLabel.font = .systemFont(ofSize: 14)
        emailLabel.textColor = .gray
        
        ticketsSectionLabel.text = "My Tickets"
        ticketsSectionLabel.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    /// 티켓 뷰 설정
    private func setupTicketView() {
        ticketView.backgroundColor = .white
        ticketView.layer.cornerRadius = 12
        ticketView.layer.shadowColor = UIColor.black.cgColor
        ticketView.layer.shadowOpacity = 0.1
        ticketView.layer.shadowOffset = CGSize(width: 0, height: 2)
        ticketView.layer.shadowRadius = 4
    }
    
    /// 테이블뷰 설정
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookingCell")
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    /// 로그아웃 버튼 설정
    private func setupLogoutButton() {
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
    }
    
    /// 사용자 데이터 로드
    private func loadUserData() {
        if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            emailLabel.text = savedEmail
        }
        
        if let savedName = UserDefaults.standard.string(forKey: "userName") {
            nameLabel.text = savedName
        } else if let email = emailLabel.text {
            nameLabel.text = email.components(separatedBy: "@")[0]
        }
        
        bookings = userDefaults.getBookingHistory()
    }
    
    // MARK: - Auto Layout
    /// SnapKit을 활용한 제약조건 설정
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
            make.height.equalTo(450)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    /// 로그아웃 버튼 탭 핸들러
    @objc private func logoutButtonTapped() {
        let alert = UIAlertController(title: "로그아웃",
                                    message: "로그아웃 하시겠습니까?",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            self?.userDefaults.logout()
            
            let loginVC = LoginView()
            let nav = UINavigationController(rootViewController: loginVC)
            nav.modalPresentationStyle = .fullScreen
            self?.present(nav, animated: true)
        })
        
        present(alert, animated: true)
    }
}

// MARK: - TableView Extension
extension UserPageView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath)
        let booking = bookings[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = booking.movieTitle
        content.secondaryText = "\(booking.bookingDate) \(booking.bookingTime) - \(booking.peopleCount)명"
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // 스와이프 삭제 기능 추가
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] (action, view, completion) in
            guard let self = self else { return }
            
            // 삭제 확인 알림창
            let alert = UIAlertController(title: "예매 내역 삭제",
                                        message: "이 예매 내역을 삭제하시겠습니까?",
                                        preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { _ in
                completion(false)
            })
            
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                // 데이터 소스에서 항목 삭제
                let bookingToDelete = self.bookings[indexPath.row]
                self.bookings.remove(at: indexPath.row)
                
                // UserDefaults에서도 삭제
                self.userDefaults.removeBooking(booking: bookingToDelete)
                
                // 테이블뷰에서 행 삭제
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                completion(true)
            })
            
            self.present(alert, animated: true)
        }
        
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}

// MARK: - SwiftUI Preview
@available(iOS 17.0, *)
#Preview {
    UserPageView()
}
