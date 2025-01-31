//
//  ImageData.swift
//  Jamming
//
//  Created by Claire on 1/31/25.
//

import Foundation

struct ImageData: Decodable {
    let backdrops: [ImagePath]
    let id: Int
    let posters: [ImagePath]
}

struct ImagePath: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

//struct Backdrop: Decodable {
//    let filePath: String
//    
//    enum CodingKeys: String, CodingKey {
//        case filePath = "file_path"
//    }
//}
//
//struct Poster: Decodable {
//    let filePath: String
//    
//    enum CodingKeys: String, CodingKey {
//        case filePath = "file_path"
//    }
//}
