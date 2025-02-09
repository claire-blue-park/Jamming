//
//  MbitiViewModel.swift
//  Jamming
//
//  Created by Claire on 2/8/25.
//

import Foundation


class MbtiViewModel {
    
//    var inputButtonTapTrigger: Observable<Void?> = Observable(())
    
    var inputEI: Observable<Character?> = Observable(nil)
    var inputSN: Observable<Character?> = Observable(nil)
    var inputTF: Observable<Character?> = Observable(nil)
    var inputJP: Observable<Character?> = Observable(nil)
    
    var outputIsDone: Observable<Bool> = Observable(false)
    var outputMbti: [Character?] {
        [inputEI.value, inputSN.value, inputTF.value, inputJP.value]
    }
    
    init() {
      
        inputEI.bind { [weak self] _ in
            guard let self else { return }
            checkIsDone()
        }
        
        inputSN.bind { [weak self] _ in
            guard let self else { return }
            checkIsDone()
        }
        
        inputTF.bind { [weak self] _ in
            guard let self else { return }
            checkIsDone()
        }
        
        inputJP.bind { [weak self] _ in
            guard let self else { return }
            checkIsDone()
        }
    }
    
    private func checkIsDone() {
        outputIsDone.value = !outputMbti.contains(nil)
    }
}

