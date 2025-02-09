//
//  UserDefaultsHelper.swift
//  Jamming
//
//  Created by Claire on 1/24/25.
//

import Foundation

final class UserDefaultsHelper {
    static let shared = UserDefaultsHelper()
    private init() {}
    
    private let screenKey = "SCREEN_STATUS"
    private let nicknameKey = "USER_NICKNAME"
    private let imageKey = "USER_IMAGE"
    private let dateKey = "USER_DATE"
    private let movieboxKey = "USER_MOVIEBOX"
    private let searchKey = "USER_SEARCH"
    
    // MARK: - 스크린
    func isStarted() -> Bool {
        return UserDefaults.standard.string(forKey: nicknameKey) != nil
    }
    
    // MARK: - User
    func saveUser(nickname: String, image: String) {
        if !nickname.isEmpty {
            UserDefaults.standard.set(nickname, forKey: nicknameKey)
        }
        UserDefaults.standard.set(image, forKey: imageKey)
        
        let date = DateFormatHelper.shared.getToday()
        UserDefaults.standard.set(date, forKey: dateKey)
    }
    
    func saveDate() {
//        if !nickname.isEmpty {
//            UserDefaults.standard.set(nickname, forKey: nicknameKey)
//        }
//        UserDefaults.standard.set(image, forKey: imageKey)
        
        let date = DateFormatHelper.shared.getToday()
        UserDefaults.standard.set(date, forKey: dateKey)
    }
    
    func saveNickname(nickname: String) {
        if !nickname.isEmpty {
            UserDefaults.standard.set(nickname, forKey: nicknameKey)
        }
//        UserDefaults.standard.set(image, forKey: imageKey)
//        
//        let date = DateFormatHelper.shared.getToday()
//        UserDefaults.standard.set(date, forKey: dateKey)
    }
    
    func saveImage(image: String) {
//        if !nickname.isEmpty {
//            UserDefaults.standard.set(nickname, forKey: nicknameKey)
//        }
        UserDefaults.standard.set(image, forKey: imageKey)
        
//        let date = DateFormatHelper.shared.getToday()
//        UserDefaults.standard.set(date, forKey: dateKey)
    }
    
    
    
    func getNickname() -> String {
        return UserDefaults.standard.string(forKey: nicknameKey) ?? "All.Unknown".localized()
    }
    
    func getImageName() -> String {
        return UserDefaults.standard.string(forKey: imageKey) ?? "profile_0"
    }
    
    func getRegisterDate() -> String {
        return UserDefaults.standard.string(forKey: dateKey) ?? "All.Unknown".localized()
    }

    // MARK: - data
    func saveMoviebox(movieId: Int) {
        var moviebox = UserDefaultsHelper.shared.getMoviebox()
        if !moviebox.contains(movieId) {
            moviebox.append(movieId)
        }
        UserDefaults.standard.set(moviebox, forKey: movieboxKey)
        print(UserDefaultsHelper.shared.getMoviebox())
    }
    func removeMoviebox(movieId: Int) {
        var moviebox = UserDefaultsHelper.shared.getMoviebox()
        if moviebox.contains(movieId) {
            if let index = moviebox.firstIndex(of: movieId) {
                moviebox.remove(at: index)
            }
        }
        UserDefaults.standard.set(moviebox, forKey: movieboxKey)
        print(UserDefaultsHelper.shared.getMoviebox())
    }
    func getMoviebox() -> [Int] {
        return (UserDefaults.standard.array(forKey: movieboxKey) ?? []) as! [Int]
    }
    
    func saveSearchHistory(searches: [String]) {
        UserDefaults.standard.set(searches, forKey: searchKey)
    }
    func getSearchHistory() -> [String] {
        return UserDefaults.standard.stringArray(forKey: searchKey) ?? []
    }
    
    // MARK: - Reset
    func removeAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
