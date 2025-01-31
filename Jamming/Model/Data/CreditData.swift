//
//  CreditData.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

struct CreditData: Decodable {
    let id: Int
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profilePath = "profile_path"
    }
}
