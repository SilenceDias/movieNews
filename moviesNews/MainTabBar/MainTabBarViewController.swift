//
//  MainTabBarViewController.swift
//  moviesNews
//
//  Created by Диас Мухамедрахимов on 16.01.2024.
//

import UIKit
import SwiftKeychainWrapper

class MainTabBarViewController: UITabBarController {
    
    // MARK: Properties
    private let titles: [String] = ["Home", "Favorites", "Watch List", "Find", "Profile"]
    private let icons: [UIImage?] = [
        UIImage(named: "icon_home"),
        UIImage(named: "icon_for_you"),
        UIImage(named: "icon_watch_list"),
        UIImage(named: "icon_search"),
        UIImage(named: "icon_profile")
    ]
    
    private var allViewControllers = [
        UINavigationController(rootViewController: MainViewController()),
        UINavigationController(rootViewController: FavoritesViewController()),
        WatchListiewController(),
        UINavigationController(rootViewController: SearchViewController()),
        ProfileViewController()
    ]
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTabBarViews()
    }
    
    // MARK: Methods
    private func makeTabBarViews(){
        view.backgroundColor = .white
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        tabBar.layer.masksToBounds = true
        tabBar.layer.borderColor = UIColor.black.cgColor
        tabBar.layer.borderWidth = 1.50
        setViewControllers(allViewControllers, animated: false)
        
        guard let items = self.tabBar.items else { return }
        
        for i in 0..<items.count {
            items[i].title = titles[i]
            items[i].image = icons[i]
        }
    }
}
