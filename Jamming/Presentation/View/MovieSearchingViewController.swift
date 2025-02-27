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
    let viewModel = MovieSearchingViewModel()
//    var searchedQueryDelegate: SearchedQueryDelegate?
//    private var searchHistory: [String] = []
    
    private let searchBar = UISearchBar()
    private let noValueInfoLabel = UILabel()
    private lazy var searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let layout = UICollectionViewFlowLayout()
//    private var searchData: SearchData?
//    private var movies: [MovieInfo] = [] {
//        willSet {
//            noValueInfoLabel.isHidden = !newValue.isEmpty
//            searchCollectionView.reloadData()
//        }
//    }
    
//    private var page = 1
//    private var totalPages = 0
//    private let sectionInset: CGFloat = 12
    
    // MARK: -  Network
    
//    private func callNetwork(query: String) {
//        NetworkManager.shared.callRequest(api: .search(query: query, page: page)) { [weak self] (searchData: SearchData) in
//        
//            // 처음 불러오는 경우
//            if self?.page == 1 {
//                self?.movies = searchData.results
//                self?.totalPages = searchData.totalPages
//                if !searchData.results.isEmpty {
//                    self?.scrollToTop()
//                }
//            } else {
//            // 기존 값 있는 경우
//                self?.movies.append(contentsOf: searchData.results)
//            }
//            
//            self?.searchData = searchData
//        } failureHandler: { code, message in
//            print(message)
//        }
//    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        configureCollectionView()
        
        bindData()
    }
    
    private func bindData() {
        viewModel.output.movies.bind { [weak self] _ in
            guard let self else { return }
            searchCollectionView.reloadData()
        }
        
        viewModel.output.networkResult.bind { [weak self] isSuccess in
            guard let self else { return }
            if let isSuccess {
                if isSuccess {
                    searchCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                } else {
                    // TODO: - 구분
                    showConfirmAlert(title: "네트워크 연결 실패", message: "다시 시도해주세요.")
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        viewModel.input.viewDisappearTrigget.value = ()
//        searchedQueryDelegate?.searchedQuery(queries: searchHistory.reversed())
    }
    
    override func configureNav() {
        navigationItem.title = "Searching.Title".localized()
    }
    
//    private func scrollToTop() {
//        searchCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
//    }
    

    private func configureCollectionView() {
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self
        searchCollectionView.showsVerticalScrollIndicator = false
        
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: viewModel.output.gap, bottom: 0, right: viewModel.output.gap)
        layout.minimumLineSpacing = viewModel.output.gap
  
        searchCollectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        searchBar.searchBarStyle = .minimal
        if viewModel.output.isQueryEmpty.value {
            searchBar.becomeFirstResponder()
        }
//        if searchBar.text!.isEmpty {
//            searchBar.becomeFirstResponder()
//        }
        
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
        viewModel.input.query.value = searchBar.text!
        
        viewModel.output.isQueryEmpty.bind { [weak self] isEmpty in
            guard let self else { return }
            if isEmpty {
                showConfirmAlert(title: "Alert.Title.InputQuery".localized(), message: "Alert.Message.InputQuery".localized())
            } else {
                viewModel.input.page.value = 1
                viewModel.input.searchHistory.value.append(searchBar.text!)
                // 네트워크 작업은 값이 비어 있지 않다면 뷰모델에서 작업
            }
        }
        
        
////        let query = searchBar.text!.replacingOccurrences(of: " ", with: "")
//        if viewModel.output.isQueryEmpty {
//            showConfirmAlert(title: "Alert.Title.InputQuery".localized(), message: "Alert.Message.InputQuery".localized())
//        } else {
//            viewModel.input.page.value = 1
////            page = 1
//            viewModel.input.searchHistory.value.append()
//            searchHistory.append(query)
//            callNetwork(query: query)
//        }
        
    }
}

extension MovieSearchingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.output.movies.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.getIdentifier, for: indexPath) as! SearchCollectionViewCell
        cell.configureData(movie: viewModel.output.movies.value[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let navigation = MovieDetailViewController()
        navigation.viewModel.input.movie.value = viewModel.output.movies.value[indexPath.row]
        navigationController?.pushViewController(navigation, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellsWidth = UIScreen.main.bounds.width - viewModel.output.gap * 2
        
        return CGSize(width: cellsWidth, height: cellsWidth * 0.3)
    }
    
}

extension MovieSearchingViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            viewModel.output.isEnd.bind { [weak self] isEnd in
                guard let self else { return }
                // TODO: - 비교 값이 뷰모델로...이동해야하는지
                // 현재 item.row를 매번 넘겨주는 것이 맞는가
                if isEnd { return }
                if viewModel.output.movies.value.count - 2 == item.row {
                    viewModel.input.page.value += 1
                    viewModel.input.query.value = searchBar.text!
                }
            }
            
//            if viewModel.output.isEnd == false && viewModel.output.movies.value.count - 2 == item.row {
//                viewModel.input.page.value += 1
////                callNetwork(query: searchBar.text!)
//                viewModel.input.query
//            }
        }
    }
    
}
