//
//  ProfileSectionView.swift
//  Jamming
//
//  Created by Claire on 1/27/25.
//

import UIKit
import SnapKit

final class ProfileSectionView: BaseView {
    
    var parentView: BaseViewController?
    
    private let profileImageView = UIImageView()
    private let nicknameLabel = UILabel()
    private let dateLabel = UILabel()
    private let chevronButton = UIButton()
    private let movieBoxButton = UIButton()
    
    private let profileImageViewSize = CGFloat(60)
    
    override func configureView() {
        backgroundColor = .neutral3
        layer.cornerRadius = 12
        clipsToBounds = true
        
        movieBoxButton.configuration = .activeSolidStyle("Profile.Button.MovieBox".localized())
        
        nicknameLabel.text = "테스트"
        nicknameLabel.font = .boldSystemFont(ofSize: 16)
        
        dateLabel.text = "8888.88 가입"
        dateLabel.textColor = .neutral2
        dateLabel.font = .systemFont(ofSize: 12)
        
        chevronButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        chevronButton.tintColor = .neutral2
        
        profileImageView.image = UIImage(named: "profile_0")
        profileImageView.layer.cornerRadius = profileImageViewSize / 2
        profileImageView.layer.borderColor = UIColor.main.cgColor
        profileImageView.layer.borderWidth = 4
        profileImageView.clipsToBounds = true
        
        chevronButton.addTarget(self, action: #selector(switchScreen), for: .touchUpInside)
    }
    
    @objc
    private func switchScreen() {
        let navigation = UINavigationController(rootViewController: ProfileEditingViewController())
        parentView?.present(navigation, animated: true)
    }
    
    override func setConstraints() {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 4
        stack.addArrangedSubview(nicknameLabel)
        stack.addArrangedSubview(dateLabel)
        
        [profileImageView, stack, chevronButton, movieBoxButton].forEach { view in
            addSubview(view)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
            make.size.equalTo(profileImageViewSize)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(stack.snp.centerY)
            make.size.equalTo(44)
        }
        
        stack.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalTo(chevronButton.snp.leading).offset(-12)
        }
        
        movieBoxButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.leading.equalTo(profileImageView.snp.leading)
            make.trailing.equalTo(chevronButton.snp.trailing)
            make.height.equalTo(44)
        }
        
    }
    
}
