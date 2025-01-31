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
    
    override func configureNav() {
        title = "Profile.Title.Setting".localized()
    }
    
    override func configureView() {
        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
        
        doneButton.configuration = .activeBorderStyle("Profile.Button.Done".localized())
        doneButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
        
        nicknameTextField.actualTextField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }
    
    @objc
    private func onEditingChanged(_ textField: UITextField) {
        
        do {
            errorLabel.text = try checkNickname(text: textField.text!)
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
    
    private func checkNickname(text: String) throws -> String {
        
        let textArray = text.replacingOccurrences(of: " ", with: "").split(separator: "")
        
        // 0. 값없음
        guard textArray.count != 0 else {
            throw NicknameError.noValue
        }
        
        // 1. 숫자 포함 불가
        let number = textArray.contains{ Int($0) != nil }
        guard !number else {
            throw NicknameError.number
        }
        
        // 2. 특수문자 포함 불가
        let special: [Character] = ["@", "#", "$", "%"]
        guard !textArray.contains(where: { special.contains($0) }) else {
            throw NicknameError.special
        }
        
        // 3. 2글자 이상 10글자 미만
        guard 2 <= textArray.count && textArray.count < 10 else {
            throw NicknameError.charCount
        }
        
        return "Profile.Error.ValidName".localized()
    }
}

