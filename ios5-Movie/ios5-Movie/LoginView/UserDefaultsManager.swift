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
        static let userPassword = "userPassword"
        static let userName = "userName"
        static let bookingHistory = "bookingHistory"
    }
    
    // 예매 정보 구조체
    struct BookingInfo: Codable {
        let movieTitle: String
        let bookingDate: String
        let bookingTime: String
        let peopleCount: Int
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
    
    // 예매 정보 저장
    func saveBookingInfo(movieTitle: String, bookingDate: String, bookingTime: String, peopleCount: Int) {
        let newBooking = BookingInfo(movieTitle: movieTitle,
                                   bookingDate: bookingDate,
                                   bookingTime: bookingTime,
                                   peopleCount: peopleCount)
        
        var bookings = getBookingHistory()
        bookings.append(newBooking)
        
        if let encoded = try? JSONEncoder().encode(bookings) {
            defaults.set(encoded, forKey: Keys.bookingHistory)
        }
    }
    
    // 모든 예매 정보 가져오기
    func getBookingHistory() -> [BookingInfo] {
        guard let data = defaults.data(forKey: Keys.bookingHistory),
              let bookings = try? JSONDecoder().decode([BookingInfo].self, from: data) else {
            return []
        }
        return bookings
    }
    
    func removeBooking(booking: BookingInfo) {
        var bookings = getBookingHistory()
        bookings.removeAll { $0.movieTitle == booking.movieTitle &&
                            $0.bookingDate == booking.bookingDate &&
                            $0.bookingTime == booking.bookingTime }
        UserDefaults.standard.set(try? JSONEncoder().encode(bookings), forKey: "bookingHistory")
    }
}
