//
//  ProfileImageViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: BaseViewController {
    
    private let profileImageButton = ProfileImageSettingButton()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureNav() {
        title = "Profile.Title.Image".localized()
    }
    
    override func configureView() {
        profileImageButton.isUserInteractionEnabled = false
    }
    
    override func setConstraints() {
        view.addSubview(profileImageButton)
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(100)
        }
        
    }
}
