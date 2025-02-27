//
//  ProfileSettingViewModel.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

import Foundation

final class ProfileSettingViewModel: BaseViewModel {
    
    var input: Input
    var output: Output
    
    struct Input {
        var name: Observable<String> = Observable("")
        var doneButtonTrigger: Observable<Void> = Observable(())
        var mbtiIsDone: Observable<Bool> = Observable(false)
        var imageNumber: Observable<Int?> = Observable(nil) // 다음 화면으로 넘겨줘야 함
    }
    
    struct Output {
        var errorMessage: Observable<String> = Observable("")
        var isDone: Observable<Bool> = Observable(false)
        var imageName: Observable<String> = Observable("")
    }

    private var isCorrectName = false
    
    init() {
        
        input = Input()
        output = Output()
        
        transform()
    }

    func transform() {
        input.mbtiIsDone.bind { [weak self] isDone in
            guard let self else { return }
            checkIsDone()
        }
        
        
        input.name.bind { [weak self] name in
            guard let self else { return }
            do {
                output.errorMessage.value = try NicknameHelper.shared.checkNickname(text: name)
                isCorrectName = true
                
            } catch NicknameError.noValue {
                output.errorMessage.value = NicknameError.noValue.errorMessage
                isCorrectName = false
                
            } catch NicknameError.number {
                output.errorMessage.value = NicknameError.number.errorMessage
                isCorrectName = false
                
            } catch NicknameError.special {
                output.errorMessage.value = NicknameError.special.errorMessage
                isCorrectName = false
                
            } catch NicknameError.charCount {
                output.errorMessage.value = NicknameError.charCount.errorMessage
                isCorrectName = false
                
            } catch {
                output.errorMessage.value = NicknameError.unknown.errorMessage
                isCorrectName = false
            }
            checkIsDone()
        }
        
        input.doneButtonTrigger.bind { [weak self] _ in
            guard let self else { return }
            UserDefaultsHelper.shared.saveDate()
            UserDefaultsHelper.shared.saveNickname(nickname: input.name.value)
            UserDefaultsHelper.shared.saveImage(image: output.imageName.value)
        }
        
        input.imageNumber.bind { [weak self] number in
            guard let self else { return }
            
            if let number {
                output.imageName.value = ProfileImageName.getImageName(number: number)
            }
        }
    }
    
    private func checkIsDone() {
        output.isDone.value = input.mbtiIsDone.value && isCorrectName
    }
    
}
