//
//  BaseViewModel.swift
//  Jamming
//
//  Created by Claire on 2/10/25.
//

import Foundation

protocol BaseViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform()
    
}
