//
//  SignUpView.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/16/24.
//

import UIKit
import SnapKit

// MARK: - SignUpView
/// 회원가입 화면을 구성하고 사용자 등록을 처리하는 뷰 컨트롤러
class SignUpView: UIViewController {
    
    // MARK: - Properties
    /// 상단 타이틀 표시용 레이블
    private let titleLabel = UILabel()
    
    /// 이전 화면으로 돌아가기 위한 버튼
    private let backButton = UIButton()
    
    /// 사용자 이름 입력 필드
    private let fullNameTextField = UITextField()
    
    /// 이메일 주소 입력 필드
    private let emailTextField = UITextField()
    
    /// 비밀번호 입력 필드
    private let passwordTextField = UITextField()
    
    /// 계정 생성 버튼
    private let createAccountButton = UIButton()
    
    private let userDefaults = UserDefaultsManager.shared
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()    // UI 요소 설정
    }
    
    // MARK: - UI Configuration
    /// UI 요소 설정 및 레이아웃 구성
    private func configureUI() {
        setupBasic()           // 기본 설정
        setupComponents()      // 컴포넌트 설정
        setupConstraints()     // 레이아웃 설정
    }
    
    /// 기본 설정
    private func setupBasic() {
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
    }
    
    /// UI 컴포넌트 설정
    private func setupComponents() {
        // 뒤로가기 버튼 설정
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        // 타이틀 레이블 설정
        titleLabel.text = "회원가입"
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        titleLabel.textColor = .black
        
        // 이름 입력필드 설정
        setupTextField(fullNameTextField, placeholder: "Full Name")
        
        // 이메일 입력필드 설정
        setupTextField(emailTextField, placeholder: "Email")
        
        // 비밀번호 입력필드 설정
        setupTextField(passwordTextField, placeholder: "Password", isSecure: true)
        
        // 계정 생성 버튼 설정
        createAccountButton.setTitle("Create Account", for: .normal)
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        createAccountButton.backgroundColor = .systemBlue
        createAccountButton.layer.cornerRadius = 12
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        // 뷰에 컴포넌트 추가
        [backButton, titleLabel, fullNameTextField, emailTextField,
         passwordTextField, createAccountButton].forEach {
            view.addSubview($0)
        }
    }
    
    /// 텍스트필드 공통 설정
    private func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false) {
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.font = .systemFont(ofSize: 16)
        textField.autocapitalizationType = .none
        textField.isSecureTextEntry = isSecure
        
        if isSecure {
            textField.isSecureTextEntry = true
            textField.textContentType = .oneTimeCode  // 자동 암호 제안 비활성화
        }
        
        // 밑줄 추가
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width - 40, height: 1)
        border.backgroundColor = UIColor.systemGray5.cgColor
        textField.layer.addSublayer(border)
    }
    
    // MARK: - Auto Layout
    /// SnapKit을 활용한 제약조건 설정
    private func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        fullNameTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(fullNameTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
    }
    
    // MARK: - Actions
    /// 뒤로가기 버튼 탭 시 이전 화면으로 이동
    @objc private func backButtonTapped() {
        let signUpVC = LoginView()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func createAccountButtonTapped() {
        guard let fullName = fullNameTextField.text, !fullName.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 알림창 표시
            let alert = UIAlertController(title: "에러",
                                        message: "모든 필드를 입력해주세요.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // UserDefaults에 이름을 포함하여 저장
        userDefaults.saveUserCredentials(email: email, password: password, name: fullName)  // 이름 추가
        
        // 성공 알림 후 로그인 화면으로 이동
        let alert = UIAlertController(title: "성공",
                                    message: "회원가입이 완료되었습니다.",
                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - SwiftUI Preview
/// 프리뷰 설정
@available(iOS 17.0, *)
#Preview {
    /*
     네비게이션 컨트롤러를 사용하는 이유:
     1. 실제 앱 환경 시뮬레이션
     2. 네비게이션 바, 타이틀, 버튼 등의 UI 요소 확인
     3. push/pop 등 네비게이션 동작 테스트
     */
    UINavigationController(
        rootViewController: SignUpView()
    )
}
