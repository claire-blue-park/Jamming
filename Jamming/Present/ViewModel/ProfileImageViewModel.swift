//
//  ProfileImageViewModel.swift
//  Jamming
//
//  Created by Claire on 2/10/25.
//

import Foundation

final class ProfileImageViewModel: BaseViewModel {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        var imageNumber: Observable<Int?> = Observable(nil)
    }
    
    struct Output {
        var imageName: Observable<String> = Observable("")
    }
    
    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.imageNumber.bind { [weak self] number in
            guard let self else { return }
            if let number {
                output.imageName.value = ProfileImageName.getImageName(number: number)
                
                // 프로필 변경 알림
                NotificationCenter.default.post(name: .profileImageNoti,
                                                object: nil,
                                                userInfo: ["imageNumber": number])
            }
        }
    }
}
