//
//  MovieSearchingViewModel.swift
//  Jamming
//
//  Created by Claire on 2/11/25.
//

import Foundation

final class MovieSearchingViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
//        var viewDisappearTrigget: Observable<Void> = Observable(())
        var searchedQueryDelegate: SearchedQueryDelegate?
        
        var query: Observable<String> = Observable("")
        var page: Observable<Int> = Observable(1)
        var searchHistory: Observable<[String]> = Observable([])
    }
    
    struct Output {
        var isQueryEmpty: Observable<Bool> = Observable(false)
        var movies: Observable<[MovieInfo]> = Observable([])
//        var movies: [MovieInfo] = [] {
//            willSet {
//                noValueInfoLabel.isHidden = !newValue.isEmpty
//                searchCollectionView.reloadData()
//            }
//        }
        
        // 검색결과
        var searchData: SearchData?
        var networkResult: Observable<Bool?> = Observable(nil)
        
        var page: Observable<Int> = Observable(1)
        var totalPages = 0
        var isEnd: Observable<Bool> {
            Observable(page.value == totalPages)
        }
        
        let gap: CGFloat = 12
    }

    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        
        input.page.bind { [weak self] page in
            guard let self else { return }
            output.page.value = page
        }
        
        input.query.bind { [weak self] query in
            guard let self else { return }
            let edit = query.replacingOccurrences(of: " ", with: "")
            output.isQueryEmpty.value = edit.isEmpty
            if !query.isEmpty { callNetwork(query: edit) }
        }
        
        // 값 배열일 필요가 있는가
        input.searchHistory.bind { [weak self] history in
            guard let self else { return }
            input.searchedQueryDelegate?.searchedQuery(queries: history.reversed())
        }
        
    }
    
    private func callNetwork(query: String) {
        NetworkManager.shared.callRequest(api: .search(query: query, page: output.page.value)) { [weak self] (searchData: SearchData) in
            guard let self else { return }
        
            // 처음 불러오는 경우
            if output.page.value == 1 {
                output.movies.value = searchData.results
                output.totalPages = searchData.totalPages
                if !searchData.results.isEmpty {
                }
            } else {
            // 기존 값 있는 경우
                output.movies.value.append(contentsOf: searchData.results)
            }
            
            output.searchData = searchData
        } failureHandler: { code, message in
//            print(message)
        }
    }
}
