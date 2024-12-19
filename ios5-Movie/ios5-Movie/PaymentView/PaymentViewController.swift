//
//  PaymentViewController.swift
//  ios5-Movie
//
//  Created by 진욱의 Macintosh on 12/13/24.
//


import UIKit
import SnapKit

class PaymentViewController: UIViewController {
    
    //var movieName: String? 상세화면 부분에서 영화 제목 api참조 예정
    var bookingDate: String?
    
    // UI 요소들
    private let bookingLabel = UILabel()
    private let movieNameTitleLabel = UILabel()
    let movieNameValueLabel = UILabel()
    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let totalPriceLabel = UILabel() // 총 금액 라벨
    private let peopleLabel = UILabel()     // 인원 수 라벨
    private let payButton = UIButton(type: .system)
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    
    private var peopleCount = 1
    private let unitPrice = 5000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDatePicker()
        updatePeopleLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 예매내역 타이틀
        bookingLabel.text = "예매내역"
        bookingLabel.font = UIFont.boldSystemFont(ofSize: 30)
        bookingLabel.textColor = .black
        view.addSubview(bookingLabel)
        
        // 영화명 레이블
        movieNameTitleLabel.text = "영화명:"
        movieNameTitleLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(movieNameTitleLabel)
        
        // 영화명 값 레이블
        
        movieNameValueLabel.font = UIFont.systemFont(ofSize: 18)
        movieNameValueLabel.textAlignment = .right
        view.addSubview(movieNameValueLabel)
        
        // 날짜 레이블
        dateLabel.text = "날짜:"
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(dateLabel)
        
        // UIDatePicker 추가
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        view.addSubview(datePicker)
        
        // 인원 수 레이블
        peopleLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(peopleLabel)
        
        // - 버튼
        minusButton.setTitle("-", for: .normal)
        minusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        minusButton.backgroundColor = .systemGray5
        minusButton.layer.cornerRadius = 8
        minusButton.addTarget(self, action: #selector(decreasePeople), for: .touchUpInside)
        view.addSubview(minusButton)
        
        // + 버튼
        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        plusButton.backgroundColor = .systemGray5
        plusButton.layer.cornerRadius = 8
        plusButton.addTarget(self, action: #selector(increasePeople), for: .touchUpInside)
        view.addSubview(plusButton)
        
        // 총 금액 레이블
        totalPriceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(totalPriceLabel)
        
        // 결제 버튼
        payButton.setTitle("결제하기", for: .normal)
        payButton.backgroundColor = .systemBlue
        payButton.tintColor = .white
        payButton.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        view.addSubview(payButton)
        
        setupConstraints()
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime // 날짜와 시간 모두 선택
        datePicker.preferredDatePickerStyle = .compact
    }
    
    private func setupConstraints() {
        // 예매내역 타이틀
        bookingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80) // 여백 줄이기
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        // 영화명 레이블 타이틀
        movieNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingLabel.snp.bottom).offset(60) // 여백 줄이기
            make.leading.equalToSuperview().offset(30)
            make.width.equalTo(80)
        }
        
        // 영화명 값 레이블 (두 줄 허용)
        movieNameValueLabel.numberOfLines = 2
        movieNameValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(movieNameTitleLabel)
            make.leading.equalTo(movieNameTitleLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        // 날짜 라벨
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameTitleLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalTo(datePicker)
        }
        
        // 날짜 선택기
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(40)
            make.centerY.equalTo(dateLabel)
            make.trailing.lessThanOrEqualToSuperview().offset(-40)
        }
        
        // 인원 수 라벨
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // - 버튼
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.leading.equalTo(peopleLabel.snp.trailing).offset(20)
            make.width.height.equalTo(30)
        }
        
        // + 버튼
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.leading.equalTo(minusButton.snp.trailing).offset(10)
            make.width.height.equalTo(30)
        }
        
        // 총 금액 라벨
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleLabel.snp.bottom).offset(70)
            make.leading.equalToSuperview().offset(30)
            make.trailing.lessThanOrEqualToSuperview().offset(-20)
        }
        
        // 결제 버튼
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-70)
            make.trailing.equalToSuperview().offset(-40)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    
    // 날짜가 선택될 시에 옆에 날짜에 표시가 되게끔
    @objc private func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" // 날짜와 시간 형식 추가
        bookingDate = formatter.string(from: datePicker.date)
        dateLabel.text = "날짜:"
    }
    
    // 인원수 옆에 +랑 - 버튼을 눌렀을 때 숫자가 그에 맞게 변하게
    @objc private func decreasePeople() {
        if peopleCount > 1 {
            peopleCount -= 1
            updatePeopleLabel()
        }
    }
    
    @objc private func increasePeople() {
        peopleCount += 1
        updatePeopleLabel()
    }
    
    //결제 하기 버튼을 눌렀을 때 얼러트창 기능을 통해서 결제가 이루어지게 하고 결제 완료를 눌렀으면 금액은 0원이 되고 인원수는 다시 1이 될 수 있게
    @objc private func payButtonTapped() {
        let alert = UIAlertController(title: "결제 확인", message: "결제를 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            // 예매 정보 저장
            let movieTitle = self.movieNameValueLabel.text ?? ""
            let date = self.bookingDate ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let time = formatter.string(from: self.datePicker.date)
            
            UserDefaultsManager.shared.saveBookingInfo(
                movieTitle: movieTitle,
                bookingDate: date,
                bookingTime: time,
                peopleCount: self.peopleCount
            )
            
            self.resetValues()


            
            // 결제 완료 알림창
            let successAlert = UIAlertController(title: "결제 완료", message: "결제가 완료되었습니다!", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                // 메인 화면으로 이동
                self.navigationController?.popToRootViewController(animated: true)
            }))
 
           

    
            self.present(successAlert, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel))
        present(alert, animated: true)
    }
    
    private func resetValues() {
        peopleCount = 1 //인원수 기본값 1로
        datePicker.date = Date()
        bookingDate = nil //날짜는 다시 초기화
        dateLabel.text = "날짜:"
        updatePeopleLabel()
    }
    
    
    // 인원수가 올라감에 따라가 가격도 변하게
    private func updatePeopleLabel() {
        peopleLabel.text = "인원: \(peopleCount)"
        let totalPrice = peopleCount * unitPrice
        totalPriceLabel.text = "총 금액: \(totalPrice)원"
    }
}
@available(iOS 17.0, *)
#Preview {
    PaymentViewController()
}
