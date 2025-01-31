//
//  NicknameError.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

enum NicknameError: Error {
    case number
    case special
    case charCount
    case noValue
    case unknown
    
    var errorMessage: String {
        switch self {
        case .number: "Profile.Error.CannorIncludeNumbers".localized()
        case .special: "Profile.Error.CannotIncludeSpecialCharacters".localized()
        case .charCount: "Profile.Error.CharactersCount".localized()
        case .noValue: ""
        case .unknown: "Profile.Error.Unknown".localized()
        }
    }
}
