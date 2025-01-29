//
//  SettingOptions.swift
//  Jamming
//
//  Created by Claire on 1/27/25.
//

import Foundation

enum SettingOptions: CaseIterable {
    
    case faQ
    case personalQ
    case noti
    case deleteAccount
    
    var options: String {
        switch self {
        case .faQ: "Setting.List.FAQ".localized()
        case .personalQ: "Setting.List.PersonalQ".localized()
        case .noti: "Setting.List.Noti".localized()
        case .deleteAccount: "Setting.List.DeleteAccount".localized()
        }
    }
}
