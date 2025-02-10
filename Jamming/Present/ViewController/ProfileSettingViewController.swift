//
//  ProfileSettingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileSettingViewController: BaseViewController {
    private let viewModel = ProfileSettingViewModel()

    private let profileImageButton = ProfileImageSettingButton()
    private let nicknameTextField = UnderLineTextField()
    private let errorLabel = UILabel()
    private let doneButton = UIButton()
    
    private let mbtiTitleLabel = UILabel()
    private let mbtiSection = MbtiSectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageButton.parentView = self

        let imageNumber = Int.random(in: 0...11)
        viewModel.input.imageNumber.value = imageNumber
        
        bindData()
    }
    
    private func bindData() {
        viewModel.output.errorMessage.bind { [weak self] message in
            guard let self else { return }
            errorLabel.text = message
        }
        
        mbtiSection.viewModel.outputIsDone.bind { [weak self] isDone in
            guard let self else { return }
            viewModel.input.mbtiIsDone.value = isDone
        }
        
        viewModel.output.isDone.bind { [weak self] isDone in
            guard let self else { return }
            let title = "Profile.Button.Done".localized()
            if isDone {
                doneButton.configuration = .activeSolidStyle(title)
                doneButton.addTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
            } else {
                doneButton.configuration = .inactiveSolidStyle(title)
                doneButton.removeTarget(self, action: #selector(onDoneButtonTapped), for: .touchUpInside)
            }
        }
        
        viewModel.output.imageName.bind { [weak self] name in
            guard let self else { return }
            profileImageButton.setImage(imageName: name)
        }
        
    }
    

    @objc
    private func onEditingChanged(_ textField: UITextField) {
        viewModel.input.name.value = textField.text ?? ""
    }
    
    @objc
    private func onDoneButtonTapped() {
        viewModel.input.doneButtonTrigger.value = ()
        
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
    }
     
    override func configureNav() {
        title = "Profile.Title.Setting".localized()
    }
    
    @objc
    private func onProfileImageButtonTapped() {
        let controller = ProfileImageViewController()
        controller.viewModel.input.imageNumber.value = viewModel.input.imageNumber.value
        controller.profileImageDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    override func configureView() {
        profileImageButton.actualButton.addTarget(self, action: #selector(onProfileImageButtonTapped), for: .touchUpInside)
        
        errorLabel.text = ""
        errorLabel.font = .systemFont(ofSize: 12)
        errorLabel.textColor = .main
        
        mbtiTitleLabel.text = "MBTI"
        mbtiTitleLabel.font = .boldSystemFont(ofSize: 16)
        
        nicknameTextField.actualTextField.addTarget(self, action: #selector(onEditingChanged), for: .editingChanged)
    }

    override func setConstraints() {
        let container = UIStackView()
        container.axis = .horizontal
        
        [profileImageButton, nicknameTextField, errorLabel, mbtiTitleLabel, mbtiSection,  doneButton].forEach { view in
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

        mbtiTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(errorLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        mbtiSection.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.top.equalTo(mbtiTitleLabel.snp.top)
        }

        doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension ProfileSettingViewController: ProfileImageDelegate {
    func profileImageChanged(imageNumber: Int) {
        viewModel.input.imageNumber.value = imageNumber
    }
    
}
