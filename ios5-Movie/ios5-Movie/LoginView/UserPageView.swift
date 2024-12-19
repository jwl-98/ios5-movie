//
//  UserPageView.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/18/24.
//

import UIKit
import SnapKit

/// 사용자의 프로필과 예매 내역을 보여주는 화면
class UserPageView: UIViewController {
  
  // MARK: - Properties
  /// UserDefaults 매니저 인스턴스
  private let userDefaults = UserDefaultsManager.shared
  
  /// 사용자 프로필 이미지를 표시하는 이미지뷰
  private let profileImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.backgroundColor = .systemGray5  // 기본 배경색 설정
      imageView.layer.cornerRadius = 40        // 원형으로 만들기 위한 라운드 처리
      imageView.clipsToBounds = true           // 이미지가 경계를 벗어나지 않도록 설정
      return imageView
  }()
  
  /// 사용자 이름을 표시하는 레이블
  private let nameLabel: UILabel = {
      let label = UILabel()
      label.text = ""                          // 초기 텍스트는 비워둠
      label.font = .systemFont(ofSize: 20, weight: .semibold)
      return label
  }()
  
  /// 사용자 이메일을 표시하는 레이블
  private let emailLabel: UILabel = {
      let label = UILabel()
      label.text = ""
      label.font = .systemFont(ofSize: 14)
      label.textColor = .gray                  // 이메일은 회색으로 표시
      return label
  }()
  
  /// "My Tickets" 섹션 제목 레이블
  private let ticketsSectionLabel: UILabel = {
      let label = UILabel()
      label.text = "My Tickets"
      label.font = .systemFont(ofSize: 18, weight: .medium)
      return label
  }()
  
  /// 예매 내역을 담는 컨테이너 뷰
  private let ticketView: UIView = {
      let view = UIView()
      view.backgroundColor = .white
      view.layer.cornerRadius = 12              // 모서리 둥글게
      // 그림자 효과 설정
      view.layer.shadowColor = UIColor.black.cgColor
      view.layer.shadowOpacity = 0.1
      view.layer.shadowOffset = CGSize(width: 0, height: 2)
      view.layer.shadowRadius = 4
      return view
  }()
  
  /// 로그아웃 버튼
  private let logoutButton: UIButton = {
      let button = UIButton(type: .system)
      button.setTitle("Logout", for: .normal)
      button.setTitleColor(.red, for: .normal)  // 로그아웃 버튼은 빨간색으로 강조
      return button
  }()
  
  /// 예매 내역을 표시할 테이블뷰
  private let tableView: UITableView = {
      let table = UITableView()
      table.register(UITableViewCell.self, forCellReuseIdentifier: "BookingCell")
      table.backgroundColor = .white
      return table
  }()
  
  /// 예매 내역 데이터를 저장할 배열
  private var bookings: [UserDefaultsManager.BookingInfo] = []
  
  // MARK: - Lifecycle Methods
  override func viewDidLoad() {
      super.viewDidLoad()
      tableView.delegate = self
      tableView.dataSource = self
      setupUI()
  }
  
  // MARK: - Setup Methods
  /// UI 초기 설정
  private func setupUI() {
      view.backgroundColor = .white
      
      // UserDefaults에서 저장된 이메일 가져와서 표시
      if let savedEmail = UserDefaults.standard.string(forKey: "userEmail") {
          emailLabel.text = savedEmail
      }
      
      // UserDefaults에서 저장된 이름 가져와서 표시
      if let savedName = UserDefaults.standard.string(forKey: "userName") {
          nameLabel.text = savedName
      } else {
          // 이름이 없는 경우 이메일의 @ 앞부분을 사용자 이름으로 표시
          if let email = emailLabel.text {
              let username = email.components(separatedBy: "@")[0]
              nameLabel.text = username
          }
      }
      
      // 화면에 UI 요소들 추가
      [profileImageView, nameLabel, emailLabel, ticketsSectionLabel,
       ticketView, logoutButton].forEach { view.addSubview($0) }
       
      // 티켓 뷰에 테이블뷰 추가
      ticketView.addSubview(tableView)
      // UserDefaults에서 예매 내역 가져오기
      bookings = userDefaults.getBookingHistory()
      
      setupConstraints()
      setupActions()
  }
  
  /// UI 요소들의 제약조건 설정
  private func setupConstraints() {
      // 각 UI 요소들의 위치와 크기 설정
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
          make.height.equalTo(300)  // 티켓 뷰 높이 설정
      }
      
      logoutButton.snp.makeConstraints { make in
          make.top.equalTo(view.safeAreaLayoutGuide)
          make.trailing.equalToSuperview().offset(-20)
      }
      
      tableView.snp.makeConstraints { make in
          make.edges.equalToSuperview()  // 테이블뷰를 티켓 뷰에 꽉 차게 설정
      }
  }
  
  /// 버튼 액션 설정
  private func setupActions() {
      // 로그아웃 버튼에 액션 추가
      logoutButton.addTarget(self,
                           action: #selector(logoutButtonTapped),
                           for: .touchUpInside)
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
          
          // 로그아웃 후 로그인 화면으로 이동
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
  /// 테이블뷰의 행 개수 반환
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return bookings.count
  }
  
  /// 테이블뷰 셀 구성
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath)
      let booking = bookings[indexPath.row]
      
      // 셀 내용 구성
      var content = cell.defaultContentConfiguration()
      content.text = booking.movieTitle
      content.secondaryText = "\(booking.bookingDate) \(booking.bookingTime) - \(booking.peopleCount)명"
      cell.contentConfiguration = content
      
      return cell
  }
  
  /// 테이블뷰 셀 높이 설정
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 60
  }
}

// MARK: - SwiftUI Preview
@available(iOS 17.0, *)
#Preview {
  UserPageView()
}
