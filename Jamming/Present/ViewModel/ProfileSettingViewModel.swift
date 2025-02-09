//
//  ProfileSettingViewModel.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

class ProfileSettingViewModel {
    
    // input
    var inputName: Observable<String> = Observable("")
    var inputUserNickname: Observable<String> = Observable("")
    var inputUserImage: Observable<String> = Observable("")
    
    var inputButtonTrigger: Observable<Void> = Observable(())
    var inputMbtiIsDone: Observable<Bool> = Observable(false)
    
    var inputImageNumber: Observable<Int?> = Observable(nil)
    
    // output
    var outputIsCorrectName: Observable<Bool> = Observable(false) // 옵저버블일 필요?
    var outputErrorMessage: Observable<String> = Observable("")
    var outputIsDone:  Observable<Bool> = Observable(false)
    
    var outputImageName: Observable<String> = Observable("")
    
    init() {
        
        inputImageNumber.bind { [weak self] number in
            guard let self else { return }
            if let number {
                outputImageName.value = "profile_\(number)"
                print(outputImageName.value)
            }
        }
        
        inputMbtiIsDone.bind { [weak self] isDone in
            guard let self else { return }
            checkIsDone()
        }
        
        
        inputName.bind { [weak self] name in
            guard let self else { return }
            do {
                outputErrorMessage.value = try NicknameHelper.shared.checkNickname(text: name)
                outputIsCorrectName.value = true
                
            } catch NicknameError.noValue {
                outputErrorMessage.value = NicknameError.noValue.errorMessage
                outputIsCorrectName.value = false
                
            } catch NicknameError.number {
                outputErrorMessage.value = NicknameError.number.errorMessage
                outputIsCorrectName.value = false
                
            } catch NicknameError.special {
                outputErrorMessage.value = NicknameError.special.errorMessage
                outputIsCorrectName.value = false
                
            } catch NicknameError.charCount {
                outputErrorMessage.value = NicknameError.charCount.errorMessage
                outputIsCorrectName.value = false
                
            } catch {
                outputErrorMessage.value = NicknameError.unknown.errorMessage
                outputIsCorrectName.value = false
            }
            checkIsDone()
        }
        
        inputUserNickname.bind { nickname in
            UserDefaultsHelper.shared.saveDate()
            UserDefaultsHelper.shared.saveNickname(nickname: nickname)
        }
        
        inputUserImage.bind { image in
            UserDefaultsHelper.shared.saveImage(image: image)
        }
        
    }
    
    private func checkIsDone() {
        outputIsDone.value = inputMbtiIsDone.value && outputIsCorrectName.value
    }
    
}
