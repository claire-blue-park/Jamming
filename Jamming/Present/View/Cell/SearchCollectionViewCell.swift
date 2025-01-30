//
//  SearchCollectionViewCell.swift
//  Jamming
//
//  Created by Claire on 1/29/25.
//

import UIKit
import Kingfisher
import SnapKit

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    private let posterImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let genreStack = UIStackView()
    private let likeButton = UIButton()
    private let separator = UIView()
    
    private let genreLabel = {
        let label = BasePaddingLabel()
        label.backgroundColor = .neutral2
        label.textColor = .neutral0
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }
    
    func configureData() {
        let test = "https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/080/189/460/80189460_1_600x600.JPG"
        posterImageView.kf.setImage(with: URL(string: test))
        movieTitleLabel.text = "그땐 그땐 그땐"
        dateLabel.text = "8888.88.88"
        let testGenre = ["액션", "SF"]
        testGenre.forEach { genre in
            let label = genreLabel()
            label.text = genre
            genreStack.addArrangedSubview(label)
        }
    }
    
    override func configureView() {
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 14)
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .neutral2
        dateLabel.numberOfLines = 2
        
        genreStack.axis = .horizontal
        genreStack.spacing = 4
        
        likeButton.configuration = .likeStyle()
        
        separator.backgroundColor = .neutral3
    }
    
    override func setConstraints() {
        [posterImageView, movieTitleLabel, dateLabel, genreStack, likeButton, separator].forEach { view in
            contentView.addSubview(view)
        }
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.horizontalEdges.equalToSuperview()
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).offset(-12)
            make.width.equalTo(80)
//            make.height.equalTo(140)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(movieTitleLabel.snp.horizontalEdges)
        }
        
        genreStack.snp.makeConstraints { make in
            make.bottom.equalTo(separator.snp.top).offset(-12)
            make.leading.equalTo(dateLabel.snp.leading)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).offset(-12)
        }
    }
}
