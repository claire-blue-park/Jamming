//
//  TrendingData.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

struct TrendingData: Decodable {
    let results: [MovieInfo]
}

struct MovieInfo: Decodable {
    let backdropPath: String?
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?
    let genreIds: [Int]?
    let releaseDate: String?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
