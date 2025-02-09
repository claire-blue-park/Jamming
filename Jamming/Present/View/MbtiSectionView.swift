//
//  MbtiSectionView.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

import UIKit
import SnapKit

final class MbtiSectionView: BaseStackView {

    let viewModel = MbtiViewModel()

    
    private let EIButton = MbtiSelectButton()
    private let SNButton = MbtiSelectButton()
    private let TFButton = MbtiSelectButton()
    private let JPButton = MbtiSelectButton()
    
    override func configureView() {
        EIButton.configureData(top: "E", bottom: "I")
        EIButton.observeValue = viewModel.inputEI
        
        SNButton.configureData(top: "S", bottom: "N")
        SNButton.observeValue = viewModel.inputSN
        
        TFButton.configureData(top: "T", bottom: "F")
        TFButton.observeValue = viewModel.inputTF
        
        JPButton.configureData(top: "J", bottom: "P")
        JPButton.observeValue = viewModel.inputJP

    }
    
    override func setConstraints() {
        axis = .horizontal
        spacing = 12
        alignment = .fill
        distribution = .fillEqually
        
        [EIButton, SNButton, TFButton, JPButton].forEach { button in
            addArrangedSubview(button)

        }
    }
    
}
