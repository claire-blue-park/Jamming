//
//  DateFormatHelper.swift
//  Jamming
//
//  Created by Claire on 1/24/25.
//

import Foundation

final class DateFormatHelper {
    static let shared = DateFormatHelper()
    private let dateFormatter = DateFormatter()
    private init() { }
    
    func getToday() -> String {
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let temp = dateFormatter.string(from: Date())
        return temp
    }

}
