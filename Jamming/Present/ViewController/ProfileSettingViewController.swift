//
//  ProfileSettingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: BaseViewController {

    private let profileImageButton = ProfileImageSettingButton()
    private let nickNameTextField = UnderLineTextField()
    private let errorLabel = UILabel()
    private let doneButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageButton.parentView = self
    }
    
    override func configureNav() {
        title = "Profile.Title.Setting".localized()
    }
    
    override func configureView() {
        errorLabel.text = "테스트"
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
        
        doneButton.configuration = .activeBorderStyle("Profile.Button.Done".localized())
        doneButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func onDoneButtonTapped() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
    }

    override func setConstraints() {
        [profileImageButton, nickNameTextField, errorLabel, doneButton].forEach { view in
            self.view.addSubview(view)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(100)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(nickNameTextField.snp.horizontalEdges).inset(12)
        }
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
    }
}
