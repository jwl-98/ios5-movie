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
    
    private func setupUI() {
        view.backgroundColor = .white
        
        // 예매내역 타이틀
        bookingLabel.text = "예매내역"
        bookingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        bookingLabel.textColor = .blue
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
        bookingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.left.equalToSuperview().offset(20)
        }
        
        movieNameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookingLabel.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(20)
            make.width.equalTo(80)
        }
        
        movieNameValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(movieNameTitleLabel)
            make.left.equalTo(movieNameTitleLabel.snp.right).offset(10)
            make.right.equalToSuperview().offset(-50)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieNameTitleLabel.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalTo(datePicker)
        }
        
        datePicker.snp.makeConstraints { make in
            make.left.equalTo(dateLabel.snp.right).offset(10)
            make.centerY.equalTo(dateLabel)
            make.right.lessThanOrEqualToSuperview().offset(-20)
        }
        
        peopleLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(20)
        }
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.left.equalTo(peopleLabel.snp.right).offset(20)
            make.width.height.equalTo(30)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(peopleLabel)
            make.left.equalTo(minusButton.snp.right).offset(10)
            make.width.height.equalTo(30)
        }
        
        totalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleLabel.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(20)
        }
        
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.right.equalToSuperview().offset(-20)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
    
    
    // 날짜가 선택될 시에 옆에 날짜에 표시가 되게끔
    @objc private func datePickerChanged() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm" // 날짜와 시간 형식 추가
        bookingDate = formatter.string(from: datePicker.date)
        dateLabel.text = "날짜: \(bookingDate ?? "")"
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
            let successAlert = UIAlertController(title: "결제 완료",
                                               message: "결제가 완료되었습니다!",
                                               preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "확인", style: .default))
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
