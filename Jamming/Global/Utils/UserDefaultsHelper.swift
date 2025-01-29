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
    
    // MARK: - Reset
    func removeAllData() {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key.description)
        }
    }
}
