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
    private let profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let profileImagesRange = 0...11
    private lazy var screenWidth = (UIScreen.main.bounds.width - sectionInset * 2 - spacing * 3) / 4
    private let sectionInset: CGFloat = 12
    private let spacing: CGFloat = 8

    override func viewDidLoad() {
        super.viewDidLoad()

        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
    }
    
    override func configureNav() {
        title = "Profile.Title.Image".localized()
    }
    
    override func configureView() {
        profileImageButton.isUserInteractionEnabled = false
        
        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
        layout.collectionView?.isScrollEnabled = false
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        profileCollectionView.collectionViewLayout = layout
        profileCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.getIdentifier)
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
        profileImagesRange.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.getIdentifier, for: indexPath) as! ProfileImageCollectionViewCell
        cell.configureData(imageName: "profile_\(indexPath.row)", radius: screenWidth / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth)
    }
}
