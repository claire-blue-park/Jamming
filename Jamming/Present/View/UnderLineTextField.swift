//
//  UnderLineTextField.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class UnderLineTextField: BaseView {
    
    private let actualTextField = UITextField()
    private let underLineView = UIView()
    
    override func configureView() {
        actualTextField.placeholder = "Profile.Placeholder".localized()
        actualTextField.borderStyle = .none
        actualTextField.font = .systemFont(ofSize: 14)
        
        underLineView.backgroundColor = .neutral2
    }
    
    override func setConstraints() {
        [actualTextField, underLineView].forEach { view in
            addSubview(view)
        }
        
        actualTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }

}
