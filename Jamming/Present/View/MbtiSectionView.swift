//
//  MbtiSectionView.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

import UIKit
import SnapKit

final class MbtiSectionView: BaseStackView {
    
    private let EIButton = MbtiSelectButton()
    private let SNButton = MbtiSelectButton()
    private let TFButton = MbtiSelectButton()
    private let JPButton = MbtiSelectButton()
    
    override func configureView() {
        EIButton.configureData(top: "E", bottom: "I")
        SNButton.configureData(top: "S", bottom: "N")
        TFButton.configureData(top: "T", bottom: "F")
        JPButton.configureData(top: "J", bottom: "P")
    }
    
    override func setConstraints() {
        axis = .horizontal
        spacing = 20
        
        [EIButton, SNButton, TFButton, JPButton].forEach { button in
            addSubview(button)
        }
    }
    
}
