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
    
    // MARK: - 스크린
    func isStarted() -> Bool {
        return UserDefaults.standard.string(forKey: nicknameKey) != nil
    }
    
    // MARK: - User
    func saveUser(nickname: String, image: String) {
        UserDefaults.standard.set(nickname, forKey: nicknameKey)
        UserDefaults.standard.set(image, forKey: imageKey)
        
        let date = DateFormatHelper.shared.getToday()
        UserDefaults.standard.set(date, forKey: dateKey)
    }
    
    func getNickname() -> String {
        return UserDefaults.standard.string(forKey: nicknameKey) ?? "Unknown"
    }
    
    func getImageName() -> String {
        return UserDefaults.standard.string(forKey: imageKey) ?? "profile_0"
    }
    
    func getRegisterDate() -> String {
        return UserDefaults.standard.string(forKey: dateKey) ?? "Unknown"
    }
    
    // MARK: - Reset
    func removeAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
