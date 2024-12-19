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
        // 예매 정보 관련 키
        static let movieTitle = "movieTitle"
        static let bookingDate = "bookingDate"
        static let bookingTime = "bookingTime"
        static let peopleCount = "peopleCount"
        
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
    
    // 사용자 이메일 저장
    func saveUserCredentials(email: String, password: String) {
        defaults.set(email, forKey: Keys.userEmail)
        defaults.set(password, forKey: Keys.userPassword)
        isLoggedIn = true
    }
    
    // 로그아웃
    func logout() {
        isLoggedIn = false
        defaults.removeObject(forKey: Keys.userEmail)
        defaults.removeObject(forKey: Keys.userPassword)
//        // 예매 정보 삭제
//        defaults.removeObject(forKey: Keys.movieTitle)
//        defaults.removeObject(forKey: Keys.bookingDate)
//        defaults.removeObject(forKey: Keys.bookingTime)
//        defaults.removeObject(forKey: Keys.peopleCount)
    }
    func saveBookingInfo(movieTitle: String, bookingDate: String, bookingTime: String, peopleCount: Int) {
        defaults.set(movieTitle, forKey: Keys.movieTitle)
        defaults.set(bookingDate, forKey: Keys.bookingDate)
        defaults.set(bookingTime, forKey: Keys.bookingTime)
        defaults.set(peopleCount, forKey: Keys.peopleCount)
    }
    
    // 예매 정보 가져오기
    func getBookingInfo() -> (title: String?, date: String?, time: String?, count: Int?) {
        let title = defaults.string(forKey: Keys.movieTitle)
        let date = defaults.string(forKey: Keys.bookingDate)
        let time = defaults.string(forKey: Keys.bookingTime)
        let count = defaults.integer(forKey: Keys.peopleCount)
        return (title, date, time, count > 0 ? count : nil)
    }
}
