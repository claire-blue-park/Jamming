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
    
    func configureData(movie: MovieInfo) {
        if let path = movie.posterPath {
            let imageUrl = PosterSize.poster500.baseURL + path
            posterImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            posterImageView.image = UIImage(systemName: "movieclapper.fill")
            posterImageView.tintColor = .neutral3
        }
        movieTitleLabel.text = movie.title
        storyLabel.text = movie.overview
    }
    
    private func callNetwork() {

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
        
        storyLabel.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalToSuperview()
        }

        movieTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(storyLabel.snp.top).offset(-12)
            make.leading.equalToSuperview()
            make.trailing.equalTo(likeButton.snp.leading).offset(-12)
        }

        likeButton.snp.makeConstraints { make in
            make.centerY.equalTo(movieTitleLabel.snp.centerY)
            make.trailing.equalToSuperview()
        }

        posterImageView.snp.makeConstraints { make in
            make.bottom.equalTo(movieTitleLabel.snp.top).offset(-12)
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}
