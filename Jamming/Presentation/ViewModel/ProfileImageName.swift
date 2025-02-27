//
//  ProfileImageName.swift
//  Jamming
//
//  Created by Claire on 2/10/25.
//

import Foundation

enum ProfileImageName {
    static func getImageName(number: Int) -> String {
        return "profile_\(number)"
    }
}
