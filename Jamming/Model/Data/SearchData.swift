//
//  SearchData.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

struct SearchData: Decodable {
    let page: Int
    let results: [MovieInfo]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
