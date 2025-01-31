//
//  MovieDetailViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    private var isFullText = false
    
    private let scrollView = UIScrollView()
    
    private let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let detailSectionView = DetailSectionView()
    
    private let synopsisTitleLabel = UILabel()
    private let moreButton = UIButton()
    private let synopsisLabel = UILabel()
    
    private let castTitleLabel = UILabel()
    private let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let posterTitleLabel = UILabel()
    private let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var trend: Trends?
    var imageData: ImageData?
    var creditData: CreditData?
    
    private let gap: CGFloat = 12
    private let heightBackdropSection: CGFloat = 280
    private let heightCastSection: CGFloat = 160
    private let heightPosterSection: CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callNetwork()
        configureCollectionView()
    }
    
    override func configureNav() {
        navigationItem.title = trend?.title
        let item = UIBarButtonItem.init(image: UIImage(systemName: "heart"),style: .plain, target: self, action: #selector(onLikeButtonTapped))
        navigationItem.rightBarButtonItem = item
    }
    
    @objc
    private func onLikeButtonTapped() {
        
    }
    
    @objc
    private func onMoreButtonTapped() {
        isFullText = !isFullText
        moreButton.configuration?.title = isFullText ? "Detail.Button.Hide".localized() : "Detail.Button.More".localized()
        synopsisLabel.numberOfLines = isFullText ? 0 : 3
    }
    
    // MARK: -  Network
    private func callNetwork() {
        let group = DispatchGroup()
        
        // 1. 이미지 API
        group.enter()
        NetworkManager.shared.callRequest(api: .image(movieId: trend?.id ?? 0)) { (imageData: ImageData) in
            self.imageData = imageData
            group.leave()
        } failureHandler: { code, message in
            print(message)
            group.leave()
        }
        
        // 2. 캐스트 API
        group.enter()
        NetworkManager.shared.callRequest(api: .credit(movieId: trend?.id ?? 0)) { (creditData: CreditData) in
            self.creditData = creditData
            group.leave()
        } failureHandler: { code, message in
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.backdropCollectionView.reloadData()
            self.castCollectionView.reloadData()
            self.posterCollectionView.reloadData()
        }
    }
    
    
    // MARK: - UI
    private func configureCollectionView() {
        let collectionViews = [backdropCollectionView, castCollectionView, posterCollectionView]
        
        // MARK: - 컬렉션뷰 고유 태그
        for index in collectionViews.indices {
            collectionViews[index].tag = index
        }
        
        // MARK: - 프로토콜 연결, 플로우 레이아웃
        collectionViews.forEach { collectionView in
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            let sectionInset: CGFloat = collectionView.tag == 0 ? 0 : gap
            let spacing: CGFloat = collectionView.tag == 0 ? 0 : gap
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            
            collectionView.isPagingEnabled = collectionView.tag == 0
            collectionView.collectionViewLayout = layout
            collectionView.showsHorizontalScrollIndicator = false
        }
        
        // MARK: - cell 등록
        backdropCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.getIdentifier)
        posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.getIdentifier)
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        detailSectionView.configureData(date: trend?.releaseDate ?? "All.Unknown".localized(),
                                        rate: trend?.voteAverage ?? 0.0,
                                        genreCodes: trend?.genreIds ?? [-1])
        
        synopsisLabel.numberOfLines = 3
        synopsisLabel.font = .systemFont(ofSize: 12)
        synopsisLabel.textColor = .neutral2
        synopsisLabel.text = trend?.overview ?? ""
        if synopsisLabel.text!.isEmpty {
            synopsisTitleLabel.isHidden = true
            moreButton.isHidden = true
        } else {
            moreButton.configuration = .plainStyle("Detail.Button.More".localized())
            moreButton.addTarget(self, action: #selector(onMoreButtonTapped), for: .touchUpInside)
            synopsisTitleLabel.text = "Detail.Title.Synopsis".localized()
        }
  
        castTitleLabel.text = "Detail.Title.Cast".localized()
        posterTitleLabel.text = "Detail.Title.Poster".localized()
        
        [synopsisTitleLabel, castTitleLabel, posterTitleLabel].forEach { label in
            label.font = .boldSystemFont(ofSize: 16)
        }
    }
    
    override func setConstraints() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        let container = UIView()
        scrollView.addSubview(container)
        
        container.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(12)
        }
        
        [backdropCollectionView, detailSectionView,
         synopsisTitleLabel, synopsisLabel, moreButton,
         castTitleLabel, castCollectionView,
         posterTitleLabel, posterCollectionView].forEach { view in
            container.addSubview(view)
        }
        
        // MARK: - 백드롭 영역
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(heightBackdropSection)
        }
        
        detailSectionView.snp.makeConstraints { make in
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - 시놉시스 영역
        synopsisTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(detailSectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(12)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(synopsisTitleLabel.snp.centerY)
        }
        
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisTitleLabel.snp.bottom).offset(12)
            make.leading.equalTo(synopsisTitleLabel.snp.leading)
            make.trailing.equalTo(moreButton.snp.trailing)
        }
        
        // MARK: - 캐스트 영역
        castTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(synopsisLabel.snp.leading)
            make.top.equalTo(synopsisLabel.snp.bottom).offset(20)
        }
        
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(heightCastSection)
        }
        
        // MARK: - 포스터 영역
        posterTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(synopsisLabel.snp.leading)
            make.top.equalTo(castCollectionView.snp.bottom).offset(20)
        }
        
        posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterTitleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(heightPosterSection)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return switch collectionView.tag {
        case 0: imageData?.backdrops.count ?? 0
        case 1: creditData?.cast.count ?? 0
        default: imageData?.posters.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.getIdentifier, for: indexPath) as! CastCollectionViewCell
            cell.configureData(cast: creditData?.cast[indexPath.row])
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.getIdentifier, for: indexPath) as! PosterCollectionViewCell
            let imagePath = collectionView.tag == 0 ? imageData?.backdrops[indexPath.row] : imageData?.posters[indexPath.row]
            cell.configureData(path: imagePath?.filePath ?? "", isBackdrop: collectionView.tag == 0)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsWidth: CGFloat = switch collectionView.tag {
        case 0: UIScreen.main.bounds.width
        case 1: UIScreen.main.bounds.width / 2.4
        default: UIScreen.main.bounds.width / 3.5
        }
        let cellsHeight: CGFloat = switch collectionView.tag {
        case 0: heightBackdropSection
        case 1: (heightCastSection - gap) / 2
        default: heightPosterSection
        }
    
        return CGSize(width: cellsWidth, height: cellsHeight)
    }
}
