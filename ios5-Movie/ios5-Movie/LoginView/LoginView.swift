//
//  LoginView.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/16/24.
//

import UIKit
import SnapKit

// MARK: - LoginView
/// 로그인 화면을 구성하고 사용자 인증을 처리하는 뷰 컨트롤러
class LoginView: UIViewController {
    
    // MARK: - Properties
    /// 로그인 화면 타이틀
    private let titleLabel = UILabel()
    
    /// 이메일 입력 필드
    private let emailTextField = UITextField()
    
    /// 비밀번호 입력 필드
    private let passwordTextField = UITextField()
    
    /// 로그인 버튼
    private let loginButton = UIButton()
    
    /// 회원가입 버튼
    private let signUpButton = UIButton()
    
    /// userDefaults 기능 추가
    private let userDefaults = UserDefaultsManager.shared
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureUI()    // UI 요소 설정
    }
    
    // MARK: - UI Configuration
    /// UI 요소 설정 및 레이아웃 구성
    private func configureUI() {
        setupBackground()     // 배경 설정
        setupComponents()     // 컴포넌트 설정
        setupConstraints()    // 레이아웃 설정
    }
    
    /// 배경 설정
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    /// UI 컴포넌트 설정
    private func setupComponents() {
        // 타이틀 레이블 설정
        titleLabel.textColor = .black
        titleLabel.text = "로그인화면"
        titleLabel.font = .systemFont(ofSize: 20, weight: .medium)
        
        // 이메일 입력필드 설정
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .none
        emailTextField.font = .systemFont(ofSize: 16)
        emailTextField.autocapitalizationType = .none
        setupUnderline(for: emailTextField)
        
        // 비밀번호 입력필드 설정
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .none
        passwordTextField.font = .systemFont(ofSize: 16)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocapitalizationType = .none
        setupUnderline(for: passwordTextField)
        
        // 로그인 버튼 설정
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        
        // 회원가입 버튼 설정
        let attributedString = NSMutableAttributedString(
            string: "회원가입이 필요하신가요?    ",
            attributes: [.foregroundColor: UIColor.gray]
        )
        attributedString.append(
            NSAttributedString(
                string: "회원가입",
                attributes: [.foregroundColor: UIColor.systemBlue]
            )
        )
        signUpButton.setAttributedTitle(attributedString, for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 14)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        // 뷰에 컴포넌트 추가
        [titleLabel, emailTextField, passwordTextField, loginButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }
    
    /// 텍스트필드 밑줄 설정
    private func setupUnderline(for textField: UITextField) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width - 40, height: 1)
        border.backgroundColor = UIColor.systemGray5.cgColor
        textField.layer.addSublayer(border)
    }
    
    // MARK: - Auto Layout
    /// SnapKit을 활용한 제약조건 설정
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(30)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(32)
        }
        
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    /// 회원가입 버튼 탭 시 회원가입 화면으로 이동
    @objc private func signUpButtonTapped() {
        let signUpVC = SignUpView()
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "에러",
                                        message: "이메일과 비밀번호를 입력해주세요.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // UserDefaults에서 저장된 값 확인
        let savedEmail = UserDefaults.standard.string(forKey: "userEmail")
        let savedPassword = UserDefaults.standard.string(forKey: "userPassword")
        let savedName = UserDefaults.standard.string(forKey: "userName")  // 이름 가져오기
        
        if email == savedEmail && password == savedPassword {
            // 이름 정보도 함께 저장
            userDefaults.saveUserCredentials(email: email, password: password, name: savedName ?? "")
            
            // 로그인 성공 시 메인 화면으로 이동
            let mainVC = MovieListViewController()
            navigationController?.setViewControllers([mainVC], animated: true)
        } else {
            let alert = UIAlertController(title: "로그인 실패",
                                        message: "이메일 또는 비밀번호가 일치하지 않습니다.",
                                        preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
        }
    }
}



// MARK: - SwiftUI Preview
@available(iOS 17.0, *)
#Preview {
    UINavigationController(
        rootViewController: LoginView()
    )
}
