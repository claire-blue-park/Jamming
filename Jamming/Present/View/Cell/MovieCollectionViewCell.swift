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
    
    private var movieId: Int?
    private var isLike = false
    
    func configureData(movie: MovieInfo) {
        if let movieId = movie.id {
            self.movieId = movieId
            isLike = UserDefaultsHelper.shared.getMoviebox().contains(movieId)
            updateLikeButtonState()
        }
        
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

    
    override func configureView() {
        updateLikeButtonState()
        likeButton.tintColor = .main
        likeButton.addTarget(self, action: #selector(onLikeButtonTapped), for: .touchUpInside)
        
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 14)
        
        storyLabel.font = .systemFont(ofSize: 12)
        storyLabel.textColor = .neutral2
        storyLabel.numberOfLines = 2
        
    }
    
    private func updateLikeButtonState() {
        let likeImage = isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    @objc
    private func onLikeButtonTapped() {
        guard let movieId else { return }
        
        isLike.toggle()
        
        if isLike {
            UserDefaultsHelper.shared.saveMoviebox(movieId: movieId)
        } else {
            UserDefaultsHelper.shared.removeMoviebox(movieId: movieId)
        }
        updateLikeButtonState()
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
            make.size.equalTo(20)
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
