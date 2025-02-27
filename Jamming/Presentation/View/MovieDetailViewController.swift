//
//  MovieDetailViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit

final class MovieDetailViewController: BaseViewController {
    // MARK: - Properties
    
//    private var isFullText = false
    let viewModel = MovieDetailViewModel()
    private let sizeViewModel = SizeDetailViewModel()
    
    private let scrollView = UIScrollView()
    
    private let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let pageControl = UIPageControl()
    private let detailSectionView = DetailSectionView()
    
    private let synopsisTitleLabel = UILabel()
    private let moreButton = UIButton()
    private let synopsisLabel = UILabel()
    
    private let castTitleLabel = UILabel()
    private let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let posterTitleLabel = UILabel()
    private let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
//    var movie: MovieInfo?
//    var imageData: ImageData?
//    var creditData: CreditData?
    
//    private let gap: CGFloat = 12
//    private let heightBackdropSection: CGFloat = 280
//    private let heightCastSection: CGFloat = 160
//    private let heightPosterSection: CGFloat = 200
    
    // MARK: -  Network
    
//    private func callNetwork() {
//        let group = DispatchGroup()
//        
//        // 1. 이미지 API
//        group.enter()
//        NetworkManager.shared.callRequest(api: .image(movieId: movie?.id ?? 0)) { [weak self] (imageData: ImageData) in
//            self?.imageData = imageData
//            group.leave()
//        } failureHandler: { code, message in
//            print(message)
//            group.leave()
//        }
//        
//        // 2. 캐스트 API
//        group.enter()
//        NetworkManager.shared.callRequest(api: .credit(movieId: movie?.id ?? 0)) { [weak self] (creditData: CreditData) in
//            self?.creditData = creditData
//            group.leave()
//        } failureHandler: { code, message in
//            group.leave()
//        }
//        
//        group.notify(queue: .main) {
//            self.backdropCollectionView.reloadData()
//            self.castCollectionView.reloadData()
//            self.posterCollectionView.reloadData()
//        }
//    }
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
//        callNetwork()
        configureCollectionView()
        bindData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    
//        let maxHeight = synopsisLabel.intrinsicContentSize.height
//        synopsisLabel.numberOfLines = 3
//        let minHeight = synopsisLabel.intrinsicContentSize.height
//        moreButton.isHidden = maxHeight <= minHeight
//        
//        print("max: \(maxHeight)")
//        print("min: \(minHeight)")
//    }
    
    private func bindData() {
        sizeViewModel.input.screenSize.value = UIScreen.main.bounds.size.width
        
        viewModel.output.isAllLeft.bind { [weak self] isAllLeft in
            guard let self else { return }
        
            backdropCollectionView.reloadData()
            castCollectionView.reloadData()
            posterCollectionView.reloadData()
            
            // 페이지 컨트롤 업데이트
            pageControl.numberOfPages = viewModel.output.imageData?.backdrops.count ?? 0
        }
    }
    
    override func configureNav() {
        if let movie = viewModel.output.movie {
            navigationItem.title = movie.title
            
            let likeButton = LikeButton()
            likeButton.configureData(movieId: movie.id)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: likeButton)
        }
    }
    
    @objc
    private func onMoreButtonTapped() {
//        isFullText = !isFullText
//        moreButton.configuration?.title = isFullText ? "Detail.Button.Hide".localized() : "Detail.Button.More".localized()
//        synopsisLabel.numberOfLines = isFullText ? 0 : 3
        
        viewModel.input.isFullText.value.toggle()
        
        moreButton.configuration?.title = viewModel.output.isFullText ? "Detail.Button.Hide".localized() : "Detail.Button.More".localized()

        synopsisLabel.numberOfLines = viewModel.output.isFullText ? 0 : 3
    }
    
    
    private func configureCollectionView() {
        let collectionViews = [backdropCollectionView, castCollectionView, posterCollectionView]
        
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
            
            let sectionInset: CGFloat = collectionView.tag == 0 ? 0 : sizeViewModel.output.gap
            let spacing: CGFloat = collectionView.tag == 0 ? 0 : sizeViewModel.output.gap
            
            layout.sectionInset = UIEdgeInsets(top: 0, left: sectionInset, bottom: 0, right: sectionInset)
            layout.minimumLineSpacing = spacing
            layout.minimumInteritemSpacing = spacing
            
            collectionView.isPagingEnabled = collectionView.tag == 0
            collectionView.collectionViewLayout = layout
            collectionView.showsHorizontalScrollIndicator = false
        }
        
        // cell 등록
        backdropCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.getIdentifier)
        posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.getIdentifier)
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.getIdentifier)
    }
    
    override func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        
        guard let movie = viewModel.output.movie else { return }
//        print(movie)
        pageControl.numberOfPages = movie.backdropPath?.count ?? 0
        pageControl.backgroundStyle = .prominent
        pageControl.currentPage = 0
        
    
        detailSectionView.configureData(date: movie.releaseDate ?? "All.Unknown".localized(),
                                        rate: movie.voteAverage ?? 0.0,
                                        genreCodes: movie.genreIds ?? [-1])
        
       
        synopsisLabel.textColor = .neutral2
//        synopsisLabel.text = movie.overview ?? ""
        requiredSynopsisHeight(labelText: movie.overview ?? "")
        print("🥹🥹🥹\(requiredSynopsisHeight(labelText: movie.overview ?? ""))")
        
//        synopsisLabel.numberOfLines = 0
        
        // 높이 UILabel 확장 구현해서 구하기
//        let lineNumber = synopsisLabel.calculateNumberOfLines()
//        print("line: \(lineNumber)")
//        synopsisLabel.numberOfLines = lineNumber < 3 ? 0 : 3
//        moreButton.isHidden = lineNumber < 3

        // intrinsicContentSize 속성으로 구하기
//        let oldLabelHeight = synopsisLabel.intrinsicContentSize.height
//        synopsisLabel.numberOfLines = 3
//        let newLabelHeight = synopsisLabel.intrinsicContentSize.height
//        moreButton.isHidden = oldLabelHeight <= newLabelHeight
        
        
        
        // 📍 TODO: - 시놉시스 외 캐스트 등이 비어있을 경우 처리
        if viewModel.output.isSynopsisEmpty {
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
    
    private func requiredSynopsisHeight(labelText: String) -> CGFloat {
        synopsisLabel.frame = CGRect(x: 0, y: 0, width: 200, height: .max)
        synopsisLabel.numberOfLines = 0
        synopsisLabel.lineBreakMode = .byWordWrapping
        synopsisLabel.font = .systemFont(ofSize: 12)
        synopsisLabel.text = labelText
        synopsisLabel.sizeToFit()
        return synopsisLabel.frame.height

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
        
        [backdropCollectionView, pageControl, detailSectionView,
         synopsisTitleLabel, synopsisLabel, moreButton,
         castTitleLabel, castCollectionView,
         posterTitleLabel, posterCollectionView].forEach { view in
            container.addSubview(view)
        }
        
        // MARK: - 백드롭 영역
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(sizeViewModel.output.heightBackdropSection)
//            make.height.equalTo(280)
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(backdropCollectionView.snp.bottom).inset(12)
            make.centerX.equalTo(backdropCollectionView.snp.centerX)
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
            make.height.equalTo(sizeViewModel.output.heightCastSection)
//            make.height.equalTo(160)
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
            make.height.equalTo(sizeViewModel.output.heightPosterSection)
//            make.height.equalTo(200)
        }
    }
}

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return switch collectionView.tag {
        case 0: viewModel.output.imageData?.backdrops.count ?? 0
        case 1: viewModel.output.creditData?.cast?.count ?? 0
        default: viewModel.output.imageData?.posters.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.getIdentifier, for: indexPath) as! CastCollectionViewCell
            cell.configureData(cast: viewModel.output.creditData?.cast?[indexPath.row])
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.getIdentifier, for: indexPath) as! PosterCollectionViewCell
            let imagePath = collectionView.tag == 0 ? viewModel.output.imageData?.backdrops[indexPath.row] : viewModel.output.imageData?.posters[indexPath.row]
            cell.configureData(path: imagePath?.filePath ?? "", isBackdrop: collectionView.tag == 0)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        sizeViewModel.input.screenSize.value = UIScreen.main.bounds.size.width
        
        let cellsWidth: CGFloat = switch collectionView.tag {
        case 0: sizeViewModel.output.widthBackdropSection
        case 1: sizeViewModel.output.widthCastSection
        default: sizeViewModel.output.widthPosterSection
        }
        let cellsHeight: CGFloat = switch collectionView.tag {
        case 0: sizeViewModel.output.heightBackdropSection
        case 1: sizeViewModel.output.cellHeightCastSection // 2분할
        default: sizeViewModel.output.heightPosterSection
        }
    
        return CGSize(width: cellsWidth, height: cellsHeight)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == backdropCollectionView {
            pageControl.currentPage = Int(floor(scrollView.contentOffset.x / UIScreen.main.bounds.width))
        }
    }
}
