//
//  CinemaViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class CinemaViewController: BaseViewController {
    
    private let profileSectionView = ProfileSectionView()
    
    private let searchTitleLabel = UILabel()
    private let searchInfoLabel = UILabel()
    private let searchDeleteAllButton = UIButton()
    private let searchScrollView = UIScrollView()
    
    private let movieTitleLabel = UILabel()
    private let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let sectionInset: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSectionView.parentView = self
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    override func configureNav() {
        navigationItem.title = "Tab.First.Title".localized()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "magnifyingglass"),
                                                                                       style: .plain,
                                                                                       target: self,
                                                                                       action: #selector(switchScreen))
    }
    
    @objc
    private func switchScreen() {
        navigationController?.pushViewController(MovieSearchingViewController(), animated: true)
    }
    
    override func configureView() {
        searchTitleLabel.text = "Tab.First.SubTitle.Search".localized()
        searchTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        searchInfoLabel.text = "Tab.First.SubTitle.Search.Info".localized()
        searchInfoLabel.textColor = .neutral2
        searchInfoLabel.font = .systemFont(ofSize: 12)
        
        searchDeleteAllButton.configuration = .plainStyle("Tab.First.SubTitle.Search.Button".localized())
        
        movieTitleLabel.text = "Tab.First.SubTitle.Movies".localized()
        movieTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumInteritemSpacing = 12
        movieCollectionView.collectionViewLayout = layout
        movieCollectionView.showsHorizontalScrollIndicator = false
        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.getIdentifier)
    }
    
    override func setConstraints() {
        [profileSectionView,
         searchTitleLabel,
         searchInfoLabel,
         searchDeleteAllButton,
         searchScrollView,
         movieTitleLabel,
         movieCollectionView].forEach { view in
            self.view.addSubview(view)
        }
        
        profileSectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(150)
        }
        
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileSectionView.snp.bottom).offset(20)
            make.leading.equalTo(profileSectionView.snp.leading)
        }
        
        searchDeleteAllButton.snp.makeConstraints { make in
            make.trailing.equalTo(profileSectionView.snp.trailing)
            make.centerY.equalTo(searchTitleLabel.snp.centerY)
        }
        
        searchScrollView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchInfoLabel.snp.makeConstraints { make in
            make.center.equalTo(searchScrollView.snp.center)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(searchScrollView.snp.bottom).offset(12)
            make.leading.equalTo(profileSectionView.snp.leading)
        }
        
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension CinemaViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.getIdentifier, for: indexPath) as! MovieCollectionViewCell
        cell.configureData()
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        navigationController?.pushViewController(MovieDetailViewController(), animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsWidth = (UIScreen.main.bounds.width - sectionInset * 2) * 0.6
        let cellsHeight = cellsWidth * 1.6

        return CGSize(width: cellsWidth, height: cellsHeight)
    }
}
