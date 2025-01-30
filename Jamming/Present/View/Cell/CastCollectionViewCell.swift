//
//  CastCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    private let actorImageView = UIImageView()
    private let krNameLabel = UILabel()
    private let enNameLabel = UILabel()
    
    private let imageSize: CGFloat = 60
    
    func configureData() {
        let test = "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/189/460/80189460_1_600x600.JPG"
        actorImageView.kf.setImage(with: URL(string: test))
        krNameLabel.text = "테스트"
        enNameLabel.text = "test"
    }
    
    override func configureView() {
        actorImageView.layer.cornerRadius = imageSize / 2
        actorImageView.clipsToBounds = true
        actorImageView.contentMode = .scaleAspectFit
        
        krNameLabel.font = .boldSystemFont(ofSize: 14)
        
        enNameLabel.font = .systemFont(ofSize: 12)
        enNameLabel.textColor = .neutral2
    }
    
    override func setConstraints() {
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.addArrangedSubview(krNameLabel)
        stack.addArrangedSubview(enNameLabel)
        
        contentView.addSubview(actorImageView)
        contentView.addSubview(stack)
        
        actorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(12)
            make.centerY.equalTo(actorImageView.snp.centerY)
        }
        
    }
}
