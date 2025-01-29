//
//  ProfileEditingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileEditingViewController: BaseViewController {
    
    private let profileImageButton = ProfileImageSettingButton()
    private let nickNameTextField = UnderLineTextField()
    private let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageButton.parentView = self
    }
    
    override func configureNav() {
        title = "Profile.Title.Editing".localized()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(switchScreenWithoutSave))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile.Button.Save".localized(),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(switchScreenWithSave))
    }
    
    @objc
    private func switchScreenWithSave() {
        dismiss(animated: true)
    }
    
    @objc
    private func switchScreenWithoutSave() {
        dismiss(animated: true)
    }
    
    override func configureView() {
        errorLabel.text = "테스트"
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
    }
    
    @objc
    private func onDoneButtonTapped() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
    }

    override func setConstraints() {
        [profileImageButton, nickNameTextField, errorLabel].forEach { view in
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
    }
}
