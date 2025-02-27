//
//  CinemaViewModel.swift
//  Jamming
//
//  Created by Claire on 2/11/25.
//

import Foundation

final class CinemaViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var viewDidLoadTrigger: Observable<Void?> = Observable(nil)
        var newSearches: Observable<[String]?> = Observable(nil)
        var remove: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        var movies: Observable<[MovieInfo]?> = Observable(nil)
        var searches: Observable<[String]?> = Observable(nil)
        

    }
    
    
    
    init() {
        input = Input()
        output = Output()
        
        getSearchHistory()
        transform()
    }
    
    func transform() {
        input.viewDidLoadTrigger.bind { [weak self] _ in
            guard let self else { return }
            callNetwork()
        }
        
        
        // 새 검색어 배열 들어옴
        input.newSearches.bind { [weak self] new in
            guard let self else { return }
            guard let new else { return }
            
            // 빈배열이 아닌 경우 - 검색이 일어난 경우
            if new.isEmpty { return }
            output.searches.value = (new + (output.searches.value ?? [])).uniqued()
            
            
            // 새 배열 저장??? - 여기서???
            UserDefaultsHelper.shared.saveSearchHistory(searches: output.searches.value ?? [])

        }
        
        input.remove.bind { [weak self] index in
            guard let self else { return }
            if let index {
                output.searches.value?.remove(at: index)
            }
        }
    }
    
    // MARK: -  Network
    
    private func callNetwork() {
        NetworkManager.shared.callRequest(api: .trending) { [weak self] (trendingData: TrendingData) in
            guard let self else { return }
            print(#function)
            output.movies.value = trendingData.results
//            self?.movies = trendingData.results
        } failureHandler: { code, message in
            print(message)
        }
    }
    
    private func getSearchHistory() {
        output.searches.value = UserDefaultsHelper.shared.getSearchHistory()
    }
    

}
