//
//  HistoryCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import SnapKit

final class HistoryCollectionViewCell: BaseCollectionViewCell {
    var deleteSearch: (() -> Void)?
    
    private let searchTextLabel = UILabel()
    private let deleteImageView = UIImageView(image: UIImage(systemName: "xmark"))
    private let actualButton = UIButton()
    
    private let cellHeight: CGFloat = 28
    
    func configureData(searchText: String) {
        searchTextLabel.text = searchText
    }
    
    override func configureView() {
        contentView.backgroundColor = .neutral1
        contentView.layer.cornerRadius = cellHeight / 2
        contentView.clipsToBounds = true
        
        searchTextLabel.font = .systemFont(ofSize: 14)
        searchTextLabel.textColor = .neutral4
        
        deleteImageView.tintColor = .neutral4
        deleteImageView.contentMode = .scaleAspectFill
        
        actualButton.addTarget(self, action: #selector(onDeleteButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func onDeleteButtonTapped() {
        deleteSearch?()
    }
    
    override func setConstraints() {
        [searchTextLabel, deleteImageView, actualButton].forEach { view in
            contentView.addSubview(view)
        }
        
        searchTextLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(8)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.leading.equalTo(searchTextLabel.snp.trailing).offset(4)
            make.trailing.verticalEdges.equalToSuperview().inset(8)
            make.size.equalTo(12)
        }
        
        actualButton.snp.makeConstraints { make in
            make.leading.equalTo(deleteImageView)
            make.trailing.verticalEdges.equalToSuperview()
        }
        
    }
}
