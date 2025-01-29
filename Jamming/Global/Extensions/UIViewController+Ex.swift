//
//  UIViewController+Ex.swift
//  Jamming
//
//  Created by Claire on 1/24/25.
//

import UIKit

extension UIViewController: Identifier {
    
    static var getIdentifier: String {
        return String(describing: self)
    }
    
    func showConfirmAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel){ _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
    func showSelectAlert(title: String, message: String, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default){ _ in
            handler()
            alert.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "취소", style: .destructive){ _ in
            alert.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    
}
