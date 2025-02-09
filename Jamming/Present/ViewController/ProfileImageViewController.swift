//
//  ProfileImageViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: BaseViewController {
    var viewModel: ProfileSettingViewModel?

    private let profileImageButton = ProfileImageSettingButton()
    private let profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private lazy var screenWidth = (UIScreen.main.bounds.width - sectionInset * 2 - spacing * 3) / 4
    private let sectionInset: CGFloat = 12
    private let spacing: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        bindData()
    }
    
    private func bindData() {
        viewModel?.outputImageName.bind { [weak self] name in
            guard let self else { return }
            profileImageButton.setImage(imageName: name)
        }
    }
    
    override func configureNav() {
        title = "Profile.Title.Image".localized()

    }
    
    private func configureCollectionView() {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.collectionView?.isScrollEnabled = false
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        profileCollectionView.collectionViewLayout = layout
        profileCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        profileImageButton.isUserInteractionEnabled = false
        profileImageButton.setImage(imageName: UserDefaultsHelper.shared.getImageName())
    }
    
    override func setConstraints() {
        view.addSubview(profileImageButton)
        view.addSubview(profileCollectionView)
        
        profileImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(100)
        }
        
        profileCollectionView.snp.makeConstraints { make in
            make.top.equalTo(profileImageButton.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension ProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.getIdentifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.configureData(imageName: "profile_\(indexPath.row)", radius: screenWidth / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel?.inputImageNumber.value = indexPath.row
    }
}
