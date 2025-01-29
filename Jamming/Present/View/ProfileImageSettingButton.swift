//
//  ProfileImageSettingButton.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageSettingButton: BaseView {
    
    var parentView: BaseViewController?
    
    private let profileImageView = UIImageView()
    private let circleView = UIView()
    private let cameraImageView = UIImageView()
    private let actualButton = UIButton()
    
    private let profileImageViewSize = CGFloat(100)
    private let circleViewSize = CGFloat(30)

    override func configureView() {
        let randomIndex = (0...11).randomElement() ?? 0
        let randomImage = UIImage(named: "profile_\(randomIndex)")
        profileImageView.image = randomImage
        profileImageView.layer.cornerRadius = profileImageViewSize / 2
        profileImageView.layer.borderColor = UIColor.main.cgColor
        profileImageView.layer.borderWidth = 4
        profileImageView.clipsToBounds = true
        
        circleView.backgroundColor = .main
        circleView.layer.cornerRadius = circleViewSize / 2
        
        cameraImageView.backgroundColor = .main
        cameraImageView.image = UIImage(systemName: "camera.fill")?.withAlignmentRectInsets(UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0))
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.tintColor = .neutral0
        
        
        actualButton.addTarget(self, action: #selector(switchScreen), for: .touchUpInside)
    }
    
    @objc
    private func switchScreen() {
        parentView?.navigationController?.pushViewController(ProfileImageViewController(), animated: true)
    }

    override func setConstraints() {
        [profileImageView, circleView, cameraImageView, actualButton].forEach { view in
            addSubview(view)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(profileImageViewSize)
        }
        
        circleView.snp.makeConstraints { make in
            make.size.equalTo(circleViewSize)
            make.trailing.bottom.equalToSuperview()
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.edges.equalTo(circleView).inset(4)
        }
        
        actualButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }

}
