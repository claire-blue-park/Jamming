//
//  MovieSearchingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class MovieSearchingViewController: BaseViewController {
    
    private let searchBar = UISearchBar()
    private let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let sectionInset: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    override func configureNav() {
        navigationItem.title = "Searching.Title".localized()
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumLineSpacing = 12
        searchCollectionView.collectionViewLayout = layout
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.getIdentifier)
    }
    
    override func setConstraints() {
        view.addSubview(searchBar)
        view.addSubview(searchCollectionView)
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MovieSearchingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension MovieSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.getIdentifier, for: indexPath) as! SearchCollectionViewCell
        cell.configureData()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsWidth = UIScreen.main.bounds.width - sectionInset * 2
        
        return CGSize(width: cellsWidth, height: cellsWidth * 0.3)
    }
    
}
