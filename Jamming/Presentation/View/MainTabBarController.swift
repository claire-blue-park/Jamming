//
//  MainTabBarController.swift
//  Jamming
//
//  Created by Claire on 1/25/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private let tabBarItems = [(title: "Tab.First".localized(), image: "popcorn"),
                               (title: "Tab.Second".localized(), image: "film.stack"),
                               (title: "Tab.Third".localized(), image: "person.crop.circle") ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        let controllers = [configureNavController(for: CinemaViewController()),
                           configureNavController(for: UpcomingViewController()),
                           configureNavController(for: SettingViewController())]
        
        for index in controllers.indices {
            controllers[index].tabBarItem.tag = index
            setTabBar(controller: controllers[index])
        }
        setViewControllers(controllers, animated: true)
        tabBar.tintColor = .main
    }
    
    private func setTabBar(controller: UIViewController) {
        let index = controller.tabBarItem.tag
        controller.tabBarItem.title = tabBarItems[index].title
        controller.tabBarItem.image = UIImage(systemName: tabBarItems[index].image)
    }
    
    private func configureNavController(for rootViewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController:  rootViewController)
        return navController
    }
    
}
