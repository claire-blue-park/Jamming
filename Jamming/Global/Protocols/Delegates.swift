//
//  SearchedQueryDelegate.swift
//  Jamming
//
//  Created by Claire on 2/1/25.
//

import Foundation

protocol SearchedQueryDelegate {
    func searchedQuery(queries: [String])
}

protocol ProfileImageDelegate {
    func profileImageChanged(imageNumber: Int)
}
