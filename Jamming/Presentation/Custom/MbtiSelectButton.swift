//
//  MbtiSelectButton.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

import UIKit
import SnapKit

final class MbtiSelectButton: BaseView {
    var observeValue: Observable<Character?>?
    
    private let topButton =  UIButton()
    private let bottomButton =  UIButton()
    
    private var buttons: [UIButton] {
        [topButton, bottomButton]
    }
    
    func configureData(top: String, bottom: String) {
//        topButton.configuration = .inactiveBorderStyle(top)
//        bottomButton.configuration = .inactiveBorderStyle(bottom)
//
//        topButton.configuration?.background.cornerRadius = 34
//        bottomButton.configuration?.background.cornerRadius = 34
        
        setButtonStyle(button: topButton, isActive: false, title: top)
        setButtonStyle(button: bottomButton, isActive: false, title: bottom)
    }
    
    private func setButtonStyle(button: UIButton, isActive: Bool, title: String?) {
        let configuration = isActive ?
        UIButton.Configuration.activeSolidStyle(title ?? "") :
        UIButton.Configuration.inactiveBorderStyle(title ?? "")
        
        button.configuration = configuration
        button.configuration?.background.cornerRadius = 34
    }
    
    override func configureView() {
        let buttons = [topButton, bottomButton]
        for index in buttons.indices {
            buttons[index].tag = index
            buttons[index].addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        }
    }
    
    @objc
    private func onButtonTapped(_ tappedButton: UIButton) {
        buttons.forEach { button in
            let title = button.titleLabel?.text
            
            if button.tag == tappedButton.tag {
                setButtonStyle(button: button, isActive: true, title: title)
                observeValue?.value = Character(title ?? "")
            } else {
                setButtonStyle(button: button, isActive: false, title: title)
            }
        }
        
    }
    
    override func setConstraints() {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 12
//        container.alignment = .fill
//        container.distribution = .fillEqually
        
        topButton.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
        bottomButton.snp.makeConstraints { make in
            make.size.equalTo(60)
        }

        
        container.addArrangedSubview(topButton)
        container.addArrangedSubview(bottomButton)
        
        addSubview(container)
        
        container.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

    }
    
}
