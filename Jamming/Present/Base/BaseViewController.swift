//
//  BaseViewController.swift
//  Jamming
//
//  Created by Claire on 1/24/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .main
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view.backgroundColor = .systemBackground
        
        configureNav()
        configureView()
        setConstraints()
    }
    
    // MARK: - 내비게이션 속성
    func configureNav() { }
    // MARK: - 뷰 속성
    func configureView() { }
    // MARK: - 뷰 배치
    func setConstraints() { }

}
