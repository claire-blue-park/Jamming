//
//  GenreCode.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

struct GenreCode {
    
    static let genre: Dictionary<Int, String> = [
        Genre.action.code: "Genre.Action".localized(),
        Genre.adventure.code: "Genre.Adventure".localized(),
        Genre.animation.code: "Genre.Animation".localized(),
        Genre.comedy.code: "Genre.Comedy".localized(),
        Genre.crime.code: "Genre.Crime".localized(),
        Genre.documentary.code: "Genre.Documentary".localized(),
        Genre.drama.code: "Genre.Drama".localized(),
        Genre.family.code: "Genre.Family".localized(),
        Genre.fantasy.code: "Genre.Fantasy".localized(),
        Genre.history.code: "Genre.History".localized(),
        Genre.horror.code: "Genre.Horror".localized(),
        Genre.mystery.code: "Genre.Mystery".localized(),
        Genre.music.code: "Genre.Music".localized(),
        Genre.romance.code: "Genre.Romance".localized(),
        Genre.sf.code: "Genre.SF".localized(),
        Genre.thriller.code: "Genre.Thriller".localized(),
        Genre.tvMovie.code: "Genre.TVMovie".localized(),
        Genre.war.code: "Genre.War".localized(),
        Genre.western.code: "Genre.Western".localized()
    ]
    
    enum Genre: Int {
        case action
        case adventure
        case animation
        case comedy
        case crime
        case documentary
        case drama
        case family
        case fantasy
        case history
        case horror
        case mystery
        case music
        case romance
        case sf
        case thriller
        case tvMovie
        case war
        case western
        case none
        
        var code: Int {
            switch self {
            case .action: 28
            case .adventure: 12
            case .animation: 16
            case .comedy: 35
            case .crime: 80
            case .documentary: 99
            case .drama: 18
            case .family: 10751
            case .fantasy: 14
            case .history: 36
            case .horror: 27
            case .mystery: 9648
            case .music: 10402
            case .romance: 10749
            case .sf: 878
            case .thriller: 53
            case .tvMovie: 10770
            case .war: 10752
            case .western: 37
            case .none: -1
            }
        }
    }
}


