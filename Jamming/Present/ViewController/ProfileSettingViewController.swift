//
//  ProfileSettingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: BaseViewController {
    private var isCorrectNickname = false

    private let profileImageButton = ProfileImageSettingButton()
    private let nicknameTextField = UnderLineTextField()
    private let errorLabel = UILabel()
    private let doneButton = UIButton()

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
        if !isCorrectNickname { return }
        
        UserDefaultsHelper.shared.saveUser(nickname: nicknameTextField.actualTextField.text!, image: profileImageButton.getImageName())
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
    }
    
    override func configureNav() {
        title = "Profile.Title.Setting".localized()
    }
    
    override func configureView() {
        profileImageButton.setImage(imageName: "profile_\((0...11).randomElement() ?? 0)")
        
        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
        
        doneButton.configuration = .activeBorderStyle("Profile.Button.Done".localized())
        doneButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
        
        nicknameTextField.actualTextField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }

    override func setConstraints() {
        [profileImageButton, nicknameTextField, errorLabel, doneButton].forEach { view in
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
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
    }
   
}

