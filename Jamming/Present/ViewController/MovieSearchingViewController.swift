//
//  MovieSearchingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class MovieSearchingViewController: BaseViewController {
    // MARK: - Properties
    
    var searchedQueryDelegate: SearchedQueryDelegate?
    private var searchHistory: [String] = []
    
    private let searchBar = UISearchBar()
    private let noValueInfoLabel = UILabel()
    private let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var searchData: SearchData?
    private var movies: [MovieInfo] = [] {
        willSet {
            noValueInfoLabel.isHidden = !newValue.isEmpty
            searchCollectionView.reloadData()
        }
    }
    
    private var page = 1
    private var totalPages = 0
    private let sectionInset: CGFloat = 12
    
    // MARK: -  Network
    
    private func callNetwork(query: String) {
        NetworkManager.shared.callRequest(api: .search(query: query, page: page)) { [weak self] (searchData: SearchData) in
        
            // 처음 불러오는 경우
            if self?.page == 1 {
                self?.movies = searchData.results
                self?.totalPages = searchData.totalPages
                if !searchData.results.isEmpty {
                    self?.scrollToTop()
                }
            } else {
            // 기존 값 있는 경우
                self?.movies.append(contentsOf: searchData.results)
            }
            
            self?.searchData = searchData
        } failureHandler: { code, message in
            print(message)
        }
    }
    
    // MARK: - Methods

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
    
    private func scrollToTop() {
        searchCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
    }
    

    private func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self
        searchCollectionView.showsVerticalScrollIndicator = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
        layout.minimumLineSpacing = 12
        searchCollectionView.collectionViewLayout = layout
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        if searchBar.text!.isEmpty {
            searchBar.becomeFirstResponder()
        }
        
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
            page = 1
            searchHistory.append(query)
            callNetwork(query: query)
        }
        
    }
}

extension MovieSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.getIdentifier, for: indexPath) as! SearchCollectionViewCell
        cell.configureData(movie: movies[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nav = MovieDetailViewController()
        nav.movie = movies[indexPath.row]
        navigationController?.pushViewController(nav, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsWidth = UIScreen.main.bounds.width - sectionInset * 2
        
        return CGSize(width: cellsWidth, height: cellsWidth * 0.3)
    }
    
}

extension MovieSearchingViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let isEnd = page == totalPages
        
        for item in indexPaths {
            if isEnd == false && movies.count - 2 == item.row {
                page += 1
                callNetwork(query: searchBar.text!)
            }
        }
    }
    
}
