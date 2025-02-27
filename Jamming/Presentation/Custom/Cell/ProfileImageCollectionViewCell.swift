//
//  ProfileImageCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import SnapKit

final class ProfileImageCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    override var isSelected: Bool {
        didSet {
            profileImageView.alpha = isSelected ? 1 : 0.5
            profileImageView.layer.borderColor = isSelected ? UIColor.main.cgColor : UIColor.neutral3.cgColor
        }
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        isSelected = false
//    }
    
    func configureData(imageName: String, radius: CGFloat) {
        
        print(isSelected)
        
        profileImageView.layer.cornerRadius = radius
        profileImageView.image = UIImage(named: imageName)
        profileImageView.alpha = isSelected ? 1 : 0.5
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderColor = isSelected ? UIColor.main.cgColor : UIColor.neutral3.cgColor
        profileImageView.layer.borderWidth = 4
        profileImageView.clipsToBounds = true
    }
    
    override func setConstraints() {
        contentView.addSubview(profileImageView)
 
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
