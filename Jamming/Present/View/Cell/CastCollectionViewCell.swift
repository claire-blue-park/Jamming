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
    private let characterLabel = UILabel()
    
    private let imageSize: CGFloat = 60
    
    func configureData(cast: Cast?) {
        guard let cast else { return }
        if let profilePath = cast.profilePath {
            actorImageView.kf.setImage(with: URL(string: ProfileSize.profile185.baseURL + profilePath))
        } else {
            actorImageView.image = UIImage(systemName: "person.circle.fill")
            actorImageView.tintColor = .neutral3
        }
        
        krNameLabel.text = cast.name
        characterLabel.text = cast.character
    }
    
    override func configureView() {
        actorImageView.layer.cornerRadius = imageSize / 2
        actorImageView.clipsToBounds = true
        actorImageView.contentMode = .scaleAspectFill
        
        krNameLabel.font = .boldSystemFont(ofSize: 14)
        
        characterLabel.font = .systemFont(ofSize: 12)
        characterLabel.textColor = .neutral2
    }
    
    override func setConstraints() {
        let stack = UIStackView()
        stack.axis = .vertical
        
        stack.addArrangedSubview(krNameLabel)
        stack.addArrangedSubview(characterLabel)
        
        contentView.addSubview(actorImageView)
        contentView.addSubview(stack)
        
        actorImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(imageSize)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(actorImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalTo(actorImageView.snp.centerY)
        }
        
    }
}
