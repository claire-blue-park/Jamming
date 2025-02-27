//
//  MovieDetailViewModel.swift
//  Jamming
//
//  Created by Claire on 2/12/25.
//

import Foundation

final class MovieDetailViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var movie: Observable<MovieInfo?> = Observable(nil)
        var isFullText: Observable<Bool> = Observable(false)
    }
    
    struct Output {
        var isFullText = false

        var movie: MovieInfo?
        var imageData: ImageData?
        var creditData: CreditData?
        
        var isSynopsisEmpty: Bool {
            movie?.overview?.isEmpty ?? true
        }
        
        var isAllLeft: Observable<Bool> = Observable(false)
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.movie.bind { [weak self] movie in
            guard let self else { return }
//            print(movie?.id)
            output.movie = movie
            callNetwork(movieId: movie?.id ?? 0)
        }
        
        input.isFullText.bind { [weak self] isFull in
            guard let self else { return }
            output.isFullText = isFull
        }
    }
    
    private func callNetwork(movieId: Int) {
        
        print(movieId)
        let group = DispatchGroup()
        
        // 1. 이미지 API
        group.enter()
        NetworkManager.shared.callRequest(api: .image(movieId: movieId)) { [weak self] (imageData: ImageData) in
            guard let self else { return }
            
            output.imageData = imageData
            group.leave()
            
        } failureHandler: { code, message in
            print("✅ 이미지 \(code)")
            group.leave()
        }
        
        // 2. 캐스트 API
        group.enter()
        NetworkManager.shared.callRequest(api: .credit(movieId: movieId)) { [weak self] (creditData: CreditData) in
            guard let self else { return }
            
            output.creditData = creditData
            group.leave()
            
        } failureHandler: { code, message in
            print("✅ 크래딧 \(code)")
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            output.isAllLeft.value = true
        }
    }
}

