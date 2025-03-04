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
    private let likeButton = LikeButton()
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
    
    private var movieId: Int?
    private var isLike = false
    
    func configureData(movie: MovieInfo) {
        likeButton.configureData(movieId: movie.id)
    
        if let path = movie.posterPath {
            let imageUrl = PosterSize.poster154.baseURL + path
            posterImageView.kf.setImage(with: URL(string: imageUrl))
        } else {
            posterImageView.image = UIImage(systemName: "movieclapper.fill")
            posterImageView.tintColor = .neutral3
        }
        movieTitleLabel.text = movie.title
        dateLabel.text = "All.ReleaseDate".localized() + " " + "\(movie.releaseDate ?? "All.Unknown".localized())"
        
        var genre: [String] = []
        movie.genreIds?.prefix(2).forEach { code in
            let text = GenreCode.genre[code] ?? "All.Unknown".localized()
            genre.append(text)
        }

        genre.forEach { genre in
            let label = genreLabel()
            label.text = genre
            genreStack.addArrangedSubview(label)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        genreStack.arrangedSubviews.forEach { genre in
            genre.removeFromSuperview()
        }
    }
    
    override func configureView() {
        posterImageView.layer.cornerRadius = 4
        posterImageView.clipsToBounds = true
        posterImageView.contentMode = .scaleAspectFill
        
        movieTitleLabel.font = .boldSystemFont(ofSize: 14)
        movieTitleLabel.numberOfLines = 2
        
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .neutral2
        
        genreStack.axis = .horizontal
        genreStack.spacing = 4
        
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
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.top)
            make.leading.equalTo(posterImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-12)
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
            make.size.equalTo(20)
            make.trailing.equalToSuperview()
            make.bottom.equalTo(separator.snp.top).offset(-12)
        }
    }
}
