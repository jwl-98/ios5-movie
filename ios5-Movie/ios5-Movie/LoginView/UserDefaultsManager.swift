//
//  UserDefaultsManager.swift
//  ios5-Movie
//
//  Created by 유태호 on 12/17/24.
//

// UserDefaults를 포함한 iOS 앱 개발에 필요한 기본적인 데이터 타입과 기능들이 포함되어 있다
import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let isLoggedIn = "isLoggedIn"
        static let userEmail = "userEmail"
        static let userPassword = "userPassword"  // 실제 앱에서는 암호를 UserDefaults에 저장하면 안됨
        static let userName = "userName"
    }
    
    // 로그인 상태 저장
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: Keys.isLoggedIn)
        }
        set {
            defaults.set(newValue, forKey: Keys.isLoggedIn)
        }
    }
    
    // 사용자 정보 저장
    func saveUserCredentials(email: String, password: String, name: String = "") {
        defaults.set(email, forKey: Keys.userEmail)
        defaults.set(password, forKey: Keys.userPassword)
        defaults.set(name, forKey: Keys.userName)
        isLoggedIn = true
    }
    
    // 로그아웃
    func logout() {
        isLoggedIn = false
    }
}
