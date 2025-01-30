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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func configureNav() {
        navigationItem.title = "영화제목"
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "heart"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(onLikeButtonTapped))
    }
    
    @objc
    private func onLikeButtonTapped() {
        
    }
    
    @objc
    private func onMoreButtonTapped() {
        isFullText = !isFullText
        synopsisLabel.numberOfLines = isFullText ? 0 : 3
    }
    
    override func configureView() {
        detailSectionView.configureData()
        
        synopsisLabel.numberOfLines = 3
        synopsisLabel.font = .systemFont(ofSize: 12)
        synopsisLabel.textColor = .neutral2
        synopsisLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        moreButton.configuration = .plainStyle("Detail.Button.More".localized())
        moreButton.addTarget(self, action: #selector(onMoreButtonTapped), for: .touchUpInside)
        
        synopsisTitleLabel.text = "Detail.Title.Synopsis".localized()
        castTitleLabel.text = "Detail.Title.Cast".localized()
        posterTitleLabel.text = "Detail.Title.Poster".localized()
        
        [backdropCollectionView, castCollectionView, posterCollectionView].forEach { view in
            view.backgroundColor = .main
        }
        
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
            make.verticalEdges.equalToSuperview()
        }
    
        [backdropCollectionView, detailSectionView,
         synopsisTitleLabel, synopsisLabel, moreButton,
         castTitleLabel, castCollectionView,
         posterTitleLabel, posterCollectionView].forEach { view in
            container.addSubview(view)
        }
        
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(280)
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
            make.height.equalTo(200)
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
            make.height.equalTo(240)
        }
    }
}

////
////  MovieDetailViewController.swift
////  Jamming
////
////  Created by Claire on 1/25/25.
////
//
//import UIKit
//
//final class MovieDetailViewController: BaseViewController {
//    private var isFullText = false
//
//    private let scrollView = UIScrollView()
//
//    private let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//    private let detailSectionView = DetailSectionView()
//
//    private let synopsisTitleLabel = UILabel()
//    private let moreButton = UIButton()
//    private let synopsisLabel = UILabel()
//
//    private let castTitleLabel = UILabel()
//    private let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//    private let posterTitleLabel = UILabel()
//    private let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//
//    }
//
//    override func configureNav() {
//        navigationItem.title = "영화제목"
//        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage(systemName: "heart"),
//                                                                 style: .plain,
//                                                                 target: self,
//                                                                 action: #selector(onLikeButtonTapped))
//    }
//
//    @objc
//    private func onLikeButtonTapped() {
//
//    }
//
//    @objc
//    private func onMoreButtonTapped() {
//        isFullText = !isFullText
//        synopsisLabel.numberOfLines = isFullText ? 0 : 3
//    }
//
//    override func configureView() {
//        detailSectionView.configureData()
//
//        synopsisLabel.numberOfLines = 3
//        synopsisLabel.font = .systemFont(ofSize: 12)
//        synopsisLabel.textColor = .neutral2
//        synopsisLabel.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
//        moreButton.configuration = .plainStyle("Detail.Button.More".localized())
//        moreButton.addTarget(self, action: #selector(onMoreButtonTapped), for: .touchUpInside)
//
//        synopsisTitleLabel.text = "Detail.Title.Synopsis".localized()
//        castTitleLabel.text = "Detail.Title.Cast".localized()
//        posterTitleLabel.text = "Detail.Title.Poster".localized()
//
//        [backdropCollectionView, castCollectionView, posterCollectionView].forEach { view in
//            view.backgroundColor = .main
//        }
//
//        [synopsisTitleLabel, castTitleLabel, posterTitleLabel].forEach { label in
//            label.font = .boldSystemFont(ofSize: 16)
//        }
//    }
//
//    override func setConstraints() {
//        view.addSubview(scrollView)
//
//        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(view.safeAreaLayoutGuide)
//        }
//
//        let stack = UIStackView()
//        stack.axis = .vertical
//        stack.spacing = 20
//
//        scrollView.addSubview(stack)
//
//        stack.snp.makeConstraints { make in
//            make.verticalEdges.equalToSuperview()
//            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
//        }
//        stack.backgroundColor = .accent
//
//        let synopsisView = UIView()
//        [synopsisTitleLabel, synopsisLabel, moreButton].forEach { view in
//            synopsisView.addSubview(view)
//        }
//
//        [backdropCollectionView, detailSectionView,
//         synopsisView,
//         castTitleLabel, castCollectionView,
//         posterTitleLabel, posterCollectionView].forEach { view in
//            stack.addArrangedSubview(view)
//        }
//
//        // MARK: - 백드롭 영역
//        backdropCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(280)
//        }
//
//        detailSectionView.snp.makeConstraints { make in
//
//        }
//
//        // MARK: - 시놉시스 영역 => SynopsisView
//        synopsisView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(12)
//            make.height.equalTo(100)
//        }
//
//        synopsisTitleLabel.snp.makeConstraints { make in
//            make.top.equalToSuperview()
//            make.leading.equalToSuperview()
//        }
//
//        moreButton.snp.makeConstraints { make in
//            make.trailing.equalToSuperview()
//            make.centerY.equalTo(synopsisTitleLabel.snp.centerY)
//        }
//
//        synopsisLabel.snp.makeConstraints { make in
//            make.top.equalTo(synopsisTitleLabel.snp.bottom).offset(12)
//            make.leading.equalTo(synopsisTitleLabel.snp.leading)
//            make.trailing.equalTo(moreButton.snp.trailing)
//        }
//
//        // MARK: - 캐스트 영역
//        castTitleLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(12)
//        }
//
//        castCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(200)
//        }
//
//        // MARK: - 포스터 영역
//        posterTitleLabel.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(12)
//        }
//
//        posterCollectionView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview()
//            make.height.equalTo(240)
//        }
//    }
//}
