//
//  Sequence+Ex.swift
//  Jamming
//
//  Created by Claire on 2/1/25.
//

import Foundation

extension Sequence where Element: Hashable {
    
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
