//
//  SettingListTableViewCell.swift
//  Jamming
//
//  Created by Claire on 1/27/25.
//

import UIKit
import SnapKit

class SettingListTableViewCell: BaseTableViewCell {
    
    private let titleLabel = UILabel()
    private let separator = UIView()
    
    func configureData(title: String) {
        titleLabel.text = title
        separator.backgroundColor = .neutral3
    }
    
    override func configureView() {
        titleLabel.font = .systemFont(ofSize: 14)
    }

    override func setConstraints() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(4)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
}
