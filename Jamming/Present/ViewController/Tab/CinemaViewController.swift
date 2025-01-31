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
    private let historyCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private let movieTitleLabel = UILabel()
    private let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let gap: CGFloat = 12
    
    private var trends: [Trends] = [] {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    private var searches: [String] = [ ] {
        willSet {
            historyCollectionView.reloadData()
            searchDeleteAllButton.isHidden = newValue.isEmpty
            searchInfoLabel.isHidden = !newValue.isEmpty
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSectionView.parentView = self
        callNetwork()
        configureCollectionView()
    }
    
    override func configureNav() {
        navigationItem.title = "Tab.First.Title".localized()
        let item = UIBarButtonItem.init(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(switchSearchScreen))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc
    private func switchSearchScreen() {
        navigationController?.pushViewController(MovieSearchingViewController(), animated: true)
    }
    
    // MARK: -  Network
    // trendingData > trends > trend
    private func callNetwork() {
        NetworkManager.shared.callRequest(api: .trending) { (trendingData: TrendingData) in
            self.trends = trendingData.results
        } failureHandler: { code, message in
            print(message)
        }
    }
    
    // MARK: - UI
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
            
            let sectionInset: CGFloat = gap
            let spacing: CGFloat = gap
            
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
        searchDeleteAllButton.isHidden = searches.isEmpty
        searchInfoLabel.isHidden = !searches.isEmpty
        
        searchTitleLabel.text = "Tab.First.SubTitle.Search".localized()
        searchTitleLabel.font = .boldSystemFont(ofSize: 18)
        
        searchInfoLabel.text = "Tab.First.SubTitle.Search.Info".localized()
        searchInfoLabel.textColor = .neutral2
        searchInfoLabel.font = .systemFont(ofSize: 12)
        
        searchDeleteAllButton.configuration = .plainStyle("Tab.First.SubTitle.Search.Button".localized())
        
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
        return collectionView.tag == 0 ? searches.count : trends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistoryCollectionViewCell.getIdentifier, for: indexPath) as! HistoryCollectionViewCell
            cell.configureData(searchText: searches[indexPath.row])
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.getIdentifier, for: indexPath) as! MovieCollectionViewCell
            cell.configureData(trend: trends[indexPath.row])
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch collectionView.tag {
        case 0:
            switchSearchScreen()
        default:
            let nav = MovieDetailViewController()
            nav.trend = trends[indexPath.row]
            navigationController?.pushViewController(nav, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize = CGSize(width: 0, height: 0)
    
        switch collectionView.tag {
        case 0:
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
            let textWidth = (searches[indexPath.row] as NSString).size(withAttributes: attributes as [NSAttributedString.Key: Any]).width
            cellSize = CGSize(width: textWidth + 12, height: 28)
        default:
            let screenWidth = UIScreen.main.bounds.width
            cellSize = CGSize(width: (screenWidth - gap * 2) * 0.6, height: (screenWidth - gap * 2) * 0.6 * 1.6)
        }
        
        return cellSize
    }
}
