//
//  PosterCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    
    private let posterImageView = UIImageView()
    
    func configureData(path: String, isBackdrop: Bool) {
        let basePath = isBackdrop ? BackdropSize.backdrop780.baseURL : PosterSize.poster300.baseURL
        let imageUrl = basePath + path
        posterImageView.kf.setImage(with: URL(string: imageUrl))
    }
    
    override func configureView() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
    }

    override func setConstraints() {
        contentView.addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
