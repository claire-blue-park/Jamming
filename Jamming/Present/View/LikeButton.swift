//
//  LikeButton.swift
//  Jamming
//
//  Created by Claire on 2/1/25.
//

import UIKit

final class LikeButton: BaseButton {
    private var movieId: Int?
    private var isLike: Bool = false {
        didSet {
            updateLikeButtonState()
        }
    }
    
    func configureData(movieId: Int?) {
        self.movieId = movieId
        if let movieId {
            isLike = UserDefaultsHelper.shared.getMoviebox().contains(movieId)
        }
        updateLikeButtonState()
    }
    
    override func configureView() {
        tintColor = .main
        addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func onButtonTapped() {
        guard let movieId else { return }
        
        isLike.toggle()
        
        if isLike {
            UserDefaultsHelper.shared.saveMoviebox(movieId: movieId)
        } else {
            UserDefaultsHelper.shared.removeMoviebox(movieId: movieId)
        }
        
        NotificationCenter.default.post(name: .profileUpdateNoti,
                                        object: nil,
                                        userInfo: nil)
    }
    
    private func updateLikeButtonState() {
        let likeImage = isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        setImage(likeImage, for: .normal)
    }

}
