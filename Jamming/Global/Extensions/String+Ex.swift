//
//  String+Ex.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import Foundation


extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
