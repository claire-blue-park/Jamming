//
//  MovieCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/28/25.
//

import UIKit
import Kingfisher
import SnapKit

final class MovieCollectionViewCell: BaseCollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let storyLabel = UILabel()
    private let likeButton = UIButton()
    
    func configureData() {
        let test = "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/189/460/80189460_1_600x600.JPG"
        posterImageView.kf.setImage(with: URL(string: test))
        movieTitleLabel.text = "그땐 그땐 그땐"
        storyLabel.text = "내가 잘못했어 그 지겨운 말 억지로 널 붙잡고 흐느껴온 날 내 진심을 다 알아버렸어 그런 순간들을 모면하는 법까지 연기일 수 밖에 물론 넌 그런 나를 알고 있었기에 얼굴 붉히는 일 없이 더 이상 기회는 없을 거라고 단정하며 오히려 차분하게 날 떠났어"
    }
    
    override func configureView() {
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 14)
        
        storyLabel.font = .systemFont(ofSize: 12)
        storyLabel.textColor = .neutral2
        storyLabel.numberOfLines = 2
        
        likeButton.configuration = .likeStyle()
    }
    
    override func setConstraints() {
        [posterImageView, movieTitleLabel, storyLabel, likeButton].forEach { view in
            contentView.addSubview(view)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(280)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(12)
            make.trailing.equalTo(posterImageView.snp.trailing)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.leading)
            make.centerY.equalTo(likeButton.snp.centerY)
        }
        
        storyLabel.snp.makeConstraints { make in
            make.top.equalTo(likeButton.snp.bottom).offset(12)
            make.leading.equalTo(posterImageView.snp.leading)
            make.trailing.equalTo(posterImageView.snp.trailing)
        }
        
    }
}
