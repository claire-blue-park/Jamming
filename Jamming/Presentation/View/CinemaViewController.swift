//
//  CinemaViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit
import SnapKit

final class CinemaViewController: BaseViewController {
    
    private let viewModel = CinemaViewModel()
    private let sizeViewModel = SizeCinemaViewModel()
    
    // MARK: - Properties
    private let profileSectionView = ProfileSectionView()
    
    private let searchTitleLabel = UILabel()
    private let searchInfoLabel = UILabel()
    private let searchDeleteAllButton = UIButton()
    private lazy var historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: historyFlowLayout)
    
    private let historyFlowLayout = UICollectionViewFlowLayout()

    private let movieTitleLabel = UILabel()
    private lazy var movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: movieFlowLayout)
    
    private let movieFlowLayout = UICollectionViewFlowLayout()
    
//    private var movies: [MovieInfo] = [] {
//        didSet {
//            movieCollectionView.reloadData()
//        }
//    }
    
//    private var searches: [String] = [ ] {
//        willSet {
//            UserDefaultsHelper.shared.saveSearchHistory(searches: newValue)
//            historyCollectionView.reloadData()
//            searchDeleteAllButton.isHidden = newValue.isEmpty
//            searchInfoLabel.isHidden = !newValue.isEmpty
//        }
//    }
    
 
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.input.viewDidLoadTrigger.value = ()
        
        bindData()
        
        profileSectionView.parentView = self
        
//        searches = UserDefaultsHelper.shared.getSearchHistory()

//        callNetwork()
        configureCollectionView()
    }
    
    private func bindData() {
        sizeViewModel.input.screenSize.value = UIScreen.main.bounds.size.width
        
        // 네트워크 영화 결과
        viewModel.output.movies.bind { [weak self] movies in
            guard let self else { return }
            movieCollectionView.reloadData()
        }
        
        // 검색어 히스토리
        viewModel.output.searches.bind { [weak self] searches in
            guard let self else { return }
            historyCollectionView.reloadData()
            if let searches {
                searchDeleteAllButton.isHidden = searches.isEmpty
                searchInfoLabel.isHidden = !searches.isEmpty
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        movieCollectionView.reloadData()
    }
    
    override func configureNav() {
        navigationItem.title = "Tab.First.Title".localized()
        let item = UIBarButtonItem.init(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(switchSearchScreen))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc
    private func switchSearchScreen() {
        let controller = MovieSearchingViewController()
        controller.viewModel.input.searchedQueryDelegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc
    private func onDeleteAllButtonTapped() {
        viewModel.input.newSearches.value = []
    }
    

    private func configureCollectionView() {
        let collectionViews = [historyCollectionView, movieCollectionView]
        
        // 컬렉션뷰 고유 태그
        for index in collectionViews.indices {
            collectionViews[index].tag = index
        }
        
        // 프로토콜 연결, 플로우 레이아웃
        collectionViews.forEach { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let sectionInset: CGFloat = sizeViewModel.output.gap
            let spacing: CGFloat = sizeViewModel.output.gap
            
            if collectionView.tag == 0 {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            }

            
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            
            collectionView.isPagingEnabled = collectionView.tag == 0
            collectionView.collectionViewLayout = layout
            collectionView.showsHorizontalScrollIndicator = false
        }
        
        // cell 등록
        historyCollectionView.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: HistoryCollectionViewCell.getIdentifier)
        
        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
//        searchDeleteAllButton.isHidden = searches.isEmpty
//        searchInfoLabel.isHidden = !searches.isEmpty
        
        searchTitleLabel.text = "Tab.First.SubTitle.Search".localized()
        searchTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        searchInfoLabel.text = "Tab.First.SubTitle.Search.Info".localized()
        searchInfoLabel.textColor = .neutral2
        searchInfoLabel.font = .systemFont(ofSize: 12)
        
        searchDeleteAllButton.configuration = .plainStyle("Tab.First.SubTitle.Search.Button".localized())
        searchDeleteAllButton.addTarget(self, action: #selector(onDeleteAllButtonTapped), for: .touchUpInside)
        
        movieTitleLabel.text = "Tab.First.SubTitle.Movies".localized()
        movieTitleLabel.font = .boldSystemFont(ofSize: 18)
    }
    
    
    override func setConstraints() {
        [profileSectionView,
         searchTitleLabel, searchDeleteAllButton, historyCollectionView, searchInfoLabel,
         movieTitleLabel, movieCollectionView].forEach { view in
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
        
        historyCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        searchInfoLabel.snp.makeConstraints { make in
            make.center.equalTo(historyCollectionView.snp.center)
        }
        
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(historyCollectionView.snp.bottom).offset(12)
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
        return collectionView.tag == 0 ?
        viewModel.output.searches.value?.count ?? 0 :
        viewModel.output.movies.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.getIdentifier, for: indexPath) as! HistoryCollectionViewCell
            if let searches = viewModel.output.searches.value {
                cell.configureData(searchText: searches[indexPath.row])
            }

            cell.deleteSearch = { [weak self] in
                guard let self else { return }
//                var temp = viewModel.output.searches.value
//                guard var temp = viewModel.output.searches.value else { return }
//                temp.remove(at: indexPath.row)
//                viewModel.input.newSearches.value = temp
                viewModel.input.remove.value = indexPath.row
            }
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.getIdentifier, for: indexPath) as! MovieCollectionViewCell
            if let movies = viewModel.output.movies.value {
                print(#function)
                cell.configureData(movie: movies[indexPath.row])
            }

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            let controller = MovieSearchingViewController()
            controller.viewModel.input.searchedQueryDelegate = self
            
            // 꼭 bind를 하지 않아도 되는지........
            if let searches = viewModel.output.searches.value {
                controller.historySearch(query: searches[indexPath.row])
            }
            navigationController?.pushViewController(controller, animated: true)
            
        default:
            let controller = MovieDetailViewController()
            
            if let movies = viewModel.output.movies.value {
                controller.viewModel.input.movie.value = movies[indexPath.row]
            }
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        let screenWidth = UIScreen.main.bounds.width
//        sizeViewModel.input.screenSize.value = screenWidth
        let cellSize = collectionView.tag == 0 ?
                       sizeViewModel.output.textCellSize :
                       sizeViewModel.output.cellSize
        
//        var cellSize = CGSize(width: 0, height: 0)
//    
//        switch collectionView.tag {
//        case 0:
////            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
////            if let searches = viewModel.output.searches.value {
////                let textWidth = (searches[indexPath.row] as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any]).width
//            cellSize = sizeViewModel.output.textCellSize
//            }
//            
//        default:
//            let screenWidth = UIScreen.main.bounds.width
////            cellSize = CGSize(width: (screenWidth - viewModel.output.gap * 2) * 0.6, height: (screenWidth - viewModel.output.gap * 2) * 0.6 * 1.6)
//            cellSize = sizeViewModel.output.cellSize
//        }
        
        return cellSize
    }
}

extension CinemaViewController: SearchedQueryDelegate {
    func searchedQuery(queries: [String]) {
        
        viewModel.input.newSearches.value = queries
//        if queries.isEmpty { return }
//        
//        searches = (queries + searches).uniqued()
    }
}
