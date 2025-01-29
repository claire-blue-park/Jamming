//
//  SettingViewController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    private let profileSectionView = ProfileSectionView()
    private let settingListTableView = UITableView()
    
    private let settingList: [SettingOptions] = SettingOptions.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        profileSectionView.parentView = self
        settingListTableView.delegate = self
        settingListTableView.dataSource = self
        settingListTableView.register(SettingListTableViewCell.self, forCellReuseIdentifier: SettingListTableViewCell.getIdentifier)
    }
    
    override func configureNav() {
        navigationItem.title = "Tab.Third.Title".localized()
    }
    
    override func configureView() {

        settingListTableView.isScrollEnabled = false
        settingListTableView.separatorStyle = .none
    }
    
    override func setConstraints() {
        view.addSubview(profileSectionView)
        view.addSubview(settingListTableView)
        
        profileSectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
            make.height.equalTo(150)
        }
        
        settingListTableView.snp.makeConstraints { make in
            make.top.equalTo(profileSectionView.snp.bottom).offset(20)
            make.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingListTableView.dequeueReusableCell(withIdentifier: SettingListTableViewCell.getIdentifier, for: indexPath) as! SettingListTableViewCell
        cell.configureData(title: settingList[indexPath.row].options)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
