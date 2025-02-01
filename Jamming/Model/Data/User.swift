//
//  User.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

final class User {
    static let shared = User()
    private init() { }
    
    var nickname: String {
        UserDefaultsHelper.shared.getNickname()
    }
    
    var imageName: String {
        UserDefaultsHelper.shared.getImageName()
    }
    
    var registerDate: String {
        UserDefaultsHelper.shared.getRegisterDate()
    }
    
    var moviebox: [Int] {
        UserDefaultsHelper.shared.getMoviebox()
    }
    
    var likesCount: Int {
        moviebox.count
    }
    
}
