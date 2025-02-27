//
//  SizeProfileImageViewModel.swift
//  Jamming
//
//  Created by Claire on 2/10/25.
//

import Foundation

final class SizeProfileImageViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var screenSize: Observable<CGFloat> = Observable(0)
    }
    
    struct Output {
//        lazy var screenWidth = (UIScreen.main.bounds.width - sectionInset * 2 - spacing * 3) / 4
        
        var cellWidth: CGFloat = 0
        var cellSize: CGSize = CGSize(width: 0, height: 0)
        var cellRadius: CGFloat {
            cellWidth / 2
        }
        let sectionInset: CGFloat = 12
        let spacing: CGFloat = 8
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.screenSize.bind { [weak self] screen in
            guard let self else { return }
            let totalInsets = output.sectionInset * 2
            let totalSpacing = output.spacing * 3
            let cellWidth = (screen - totalInsets - totalSpacing) / 4
            
            output.cellSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
}
