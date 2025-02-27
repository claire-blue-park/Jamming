//
//  SizeCinemaViewModel.swift
//  Jamming
//
//  Created by Claire on 2/12/25.
//

import UIKit

final class SizeCinemaViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var screenSize: Observable<CGFloat> = Observable(0)
        var text: Observable<String> = Observable("")
    }
    
    struct Output {
        var textCellSize: CGSize = CGSize(width: 0, height: 0)
        
        var cellSize: CGSize = CGSize(width: 0, height: 0)
        let gap: CGFloat = 12
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.screenSize.bind { [weak self] screen in
            guard let self else { return }

            let width = (screen - output.gap * 2) * 0.6
            let height = width * 1.6
            
            output.cellSize =  CGSize(width: width, height: height)
        }
        
        input.text.bind { [weak self] text in
            guard let self else { return }
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            let textWidth = (text as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any]).width
            output.textCellSize = CGSize(width: textWidth + 12, height: 28)
        }
    }
}

