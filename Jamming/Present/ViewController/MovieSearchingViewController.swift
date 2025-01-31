//
//  MovieSearchingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class MovieSearchingViewController: BaseViewController {
    
    var searchedQueryDelegate: SearchedQueryDelegate?
    private var searchHistory: [String] = []
    
    private let searchBar = UISearchBar()
    private let noValueInfoLabel = UILabel()
    private let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var searchData: SearchData? {
        willSet {
            noValueInfoLabel.isHidden = !(newValue?.results.isEmpty ?? true)
            searchCollectionView.reloadData()
        }
    }
    private let sectionInset: CGFloat = 12

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchedQueryDelegate?.searchedQuery(queries: searchHistory.reversed())
    }
    
    override func configureNav() {
        navigationItem.title = "Searching.Title".localized()
    }
    
    // MARK: -  Network
    private func callNetwork(query: String) {
        NetworkManager.shared.callRequest(api: .search(query: query)) { (searchData: SearchData) in
            self.searchData = searchData
        } failureHandler: { code, message in
            print(message)
        }
    }
    
    // MARK: - UI
    private func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumLineSpacing = 12
        searchCollectionView.collectionViewLayout = layout
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        searchBar.becomeFirstResponder()
        
        noValueInfoLabel.text = "Searching.Info.NoValue".localized()
        noValueInfoLabel.isHidden = true
        noValueInfoLabel.font = .systemFont(ofSize: 14)
        noValueInfoLabel.textColor = .neutral2
    }
    
    override func setConstraints() {
        [searchBar, searchCollectionView, noValueInfoLabel].forEach { view in
            self.view.addSubview(view)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noValueInfoLabel.snp.makeConstraints { make in
            make.center.equalTo(searchCollectionView.snp.center)
        }
    }
}

extension MovieSearchingViewController: UISearchBarDelegate {
    func historySearch(query: String) {
        searchBar.text = query
        searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        let query = searchBar.text!.replacingOccurrences(of: " ", with: "")
        if query.isEmpty {
            showConfirmAlert(title: "Alert.Title.InputQuery".localized(), message: "Alert.Message.InputQuery".localized())
        } else {
            searchHistory.append(query)
            callNetwork(query: query)
        }
        
    }
}

extension MovieSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchData?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.getIdentifier, for: indexPath) as! SearchCollectionViewCell
        if let movies = searchData?.results {
            cell.configureData(movie: movies[indexPath.row])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsWidth = UIScreen.main.bounds.width - sectionInset * 2
        
        return CGSize(width: cellsWidth, height: cellsWidth * 0.3)
    }
    
}
