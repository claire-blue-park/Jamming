//
//  ScreenViewModel.swift
//  Jamming
//
//  Created by Claire on 2/10/25.
//

import UIKit

final class ScreenViewModel {
    lazy var screenWidth = (UIScreen.main.bounds.width - sectionInset * 2 - spacing * 3) / 4
    let sectionInset: CGFloat = 12
    let spacing: CGFloat = 8
}
