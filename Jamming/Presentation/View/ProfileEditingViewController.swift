//
//  ProfileEditingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileEditingViewController: BaseViewController {
    private var isCorrectNickname = false
    
    private let profileImageButton = ProfileImageSettingButton()
    private let nicknameTextField = UnderLineTextField()
    private let errorLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageButton.parentView = self
        
        // 이미지 변경 감지
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ProfileImageReceivedNotification),
                                               name: .profileImageNoti,
                                               object: nil)
    }
    
    @objc
    func ProfileImageReceivedNotification(notification: NSNotification) {
        if let imageName = notification.userInfo!["imageName"] as? String {
            profileImageButton.setImage(imageName: imageName)
        } else {
            print(self, "nil: \(notification)")
        }
    }
   
    @objc
    private func onEditingChanged(_ textField: UITextField) {
        do {
            errorLabel.text = try NicknameHelper.shared.checkNickname(text: textField.text!)
            isCorrectNickname = true
        } catch NicknameError.noValue {
            errorLabel.text = NicknameError.noValue.errorMessage
            isCorrectNickname = false
        } catch NicknameError.number {
            errorLabel.text = NicknameError.number.errorMessage
            isCorrectNickname = false
        } catch NicknameError.special {
            errorLabel.text = NicknameError.special.errorMessage
            isCorrectNickname = false
        } catch NicknameError.charCount {
            errorLabel.text = NicknameError.charCount.errorMessage
            isCorrectNickname = false
        } catch {
            print(NicknameError.unknown.errorMessage)
        }
    }
    
    @objc
    private func onDoneButtonTapped() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
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
    
    // 1. 저장하면서 dismiis
    @objc
    private func switchScreenWithSave() {
        let isNicknameChanged = UserDefaultsHelper.shared.getNickname() != nicknameTextField.actualTextField.text
        let isProfileImageChanged = UserDefaultsHelper.shared.getImageName() != profileImageButton.getImageName()
        
        // 닉네임 변경되었는데 올바르지 않을 경우
        if isNicknameChanged && !isCorrectNickname { return }
        
        // 프로필 변경이 있을 경우
        if isNicknameChanged || isProfileImageChanged {
            
            // 1. 저장
            UserDefaultsHelper.shared.saveUser(nickname: nicknameTextField.actualTextField.text!, image: profileImageButton.getImageName())
            
            // 2. 프로필 변경 알림
            NotificationCenter.default.post(name: .profileUpdateNoti,
                                            object: nil,
                                            userInfo: nil)
        }
        dismiss(animated: true)
    }
    
    // 2. 저장 없이 dismiis
    @objc
    private func switchScreenWithoutSave() {
        dismiss(animated: true)
    }
    
    override func configureView() {
        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
        
        // 기존 값 가져오기
        profileImageButton.setImage(imageName: UserDefaultsHelper.shared.getImageName())
        nicknameTextField.actualTextField.text = UserDefaultsHelper.shared.getNickname()
        nicknameTextField.actualTextField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }

    override func setConstraints() {
        [profileImageButton, nicknameTextField, errorLabel].forEach { view in
            self.view.addSubview(view)
        }
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(100)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(nicknameTextField.snp.horizontalEdges).inset(12)
        }
    }

}
