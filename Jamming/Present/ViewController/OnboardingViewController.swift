//
//  OnboardingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    
    private let adImageView = UIImageView()
    private let titleLabel = UILabel()
    private let catchLabel = UILabel()
    private let startButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    override func configureView() {
        adImageView.image = UIImage(named: "onboarding")
        adImageView.contentMode = .scaleAspectFill
        
        titleLabel.text = "Onboarding.Title".localized()
        titleLabel.textAlignment = .center
        titleLabel.font = .italicSystemFont(ofSize: 40)
        
        catchLabel.text = "Onboarding.CatchPhrase".localized()
        catchLabel.textAlignment = .center
        catchLabel.font = .systemFont(ofSize: 16)
        catchLabel.numberOfLines = 2
        
        startButton.configuration = .activeBorderStyle("Onboarding.Button".localized())
        startButton.addTarget(self, action: #selector(onStartButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func onStartButtonTapped() {
        navigationController?.pushViewController(ProfileSettingViewController(), animated: true)
    }

    override func setConstraints() {
        [adImageView, titleLabel, catchLabel, startButton].forEach { view in
            self.view.addSubview(view)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(44)
        }
        catchLabel.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-24)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(catchLabel.snp.top).offset(-12)
            make.centerX.equalToSuperview()
        }
        adImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
        }
    }

}
