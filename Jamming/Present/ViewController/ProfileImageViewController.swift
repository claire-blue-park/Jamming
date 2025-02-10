//
//  ProfileImageViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileImageViewController: BaseViewController {
    var profileImageDelegate: ProfileImageDelegate?
    let viewModel = ProfileImageViewModel()
    private let screenViewModel = ScreenViewModel()

    private let profileImageButton = ProfileImageSettingButton()
    private lazy var profileCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private var layout = UICollectionViewFlowLayout()
       

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        bindData()
    }
    
    private func bindData() {
        viewModel.output.imageName.bind { [weak self] name in
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
        
        layout.collectionView?.isScrollEnabled = false
        layout.sectionInset = UIEdgeInsets(top: 0, left: screenViewModel.sectionInset, bottom: 0, right: screenViewModel.sectionInset)
        layout.minimumLineSpacing = screenViewModel.spacing
        layout.minimumInteritemSpacing = screenViewModel.spacing

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
        
        if viewModel.input.imageNumber.value == indexPath.row {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
        }
        
        cell.configureData(imageName: "profile_\(indexPath.row)", radius: screenViewModel.screenWidth / 2)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenViewModel.screenWidth, height: screenViewModel.screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.input.imageNumber.value = indexPath.row
        profileImageDelegate?.profileImageChanged(imageNumber: indexPath.row)
    }
}
