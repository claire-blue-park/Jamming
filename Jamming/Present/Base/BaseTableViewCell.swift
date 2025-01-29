//
//  BaseTableViewCell.swift
//  Jamming
//
//  Created by Claire on 1/27/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 뷰 속성
    func configureView() { }
    // MARK: - 뷰 배치
    func setConstraints() {  }
}
