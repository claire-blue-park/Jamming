//
//  SizeDetailViewModel.swift
//  Jamming
//
//  Created by Claire on 2/12/25.
//

import Foundation

final class SizeDetailViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var screenSize: Observable<CGFloat> = Observable(0)
    }
    
    struct Output {
        let gap: CGFloat = 12
        
        var widthBackdropSection: CGFloat = 0
        let heightBackdropSection: CGFloat = 280
        
        var widthCastSection: CGFloat = 0
        let heightCastSection: CGFloat = 160
        var cellHeightCastSection: CGFloat {
            (heightCastSection - gap) / 2
        }
        
        var widthPosterSection: CGFloat = 0
        let heightPosterSection: CGFloat = 200
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.screenSize.bind { [weak self] screen in
            guard let self else { return }
            output.widthBackdropSection = screen
            output.widthCastSection = screen / 2.4
            output.widthPosterSection = screen / 3.5
        }
    }
}
