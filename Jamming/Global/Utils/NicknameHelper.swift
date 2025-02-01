//
//  NicknameHelper.swift
//  Jamming
//
//  Created by Claire on 2/1/25.
//

import Foundation

final class NicknameHelper {
    static let shared = NicknameHelper()
    private init() { }
    
    func checkNickname(text: String) throws -> String {
        
        let textArray = text.replacingOccurrences(of: " ", with: "").split(separator: "")
        
        // 0. 값없음
        guard textArray.count != 0 else {
            throw NicknameError.noValue
        }
        
        // 1. 숫자 포함 불가
        let number = textArray.contains{ Int($0) != nil }
        guard !number else {
            throw NicknameError.number
        }
        
        // 2. 특수문자 포함 불가
        let special: [Character] = ["@", "#", "$", "%"]
        guard !textArray.contains(where: { special.contains($0) }) else {
            throw NicknameError.special
        }
        
        // 3. 2글자 이상 10글자 미만
        guard 2 <= textArray.count && textArray.count < 10 else {
            throw NicknameError.charCount
        }
        
        return "Profile.Error.ValidName".localized()
    }

}
