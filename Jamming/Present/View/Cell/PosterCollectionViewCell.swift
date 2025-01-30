//
//  PosterCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/30/25.
//

import UIKit
import Kingfisher
import SnapKit

class PosterCollectionViewCell: BaseCollectionViewCell {
    
    private let posterImageView = UIImageView()
    
    func configureData() {
        let test = "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/189/460/80189460_1_600x600.JPG"
        posterImageView.kf.setImage(with: URL(string: test))
    }
    
    override func configureView() {
        posterImageView.contentMode = .scaleToFill
    }

    override func setConstraints() {
        addSubview(posterImageView)
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
