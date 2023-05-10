//
//  TabBarController.swift
//  ChatApp
//
//  Created by Станислава on 05.04.2023.
//

import UIKit

class TabBarController: UITabBarController {
    private var conversationsListNavigationController: UINavigationController
    private var themesdNavigationController: UINavigationController
    private var profileNavigationController: UINavigationController
    
    init(
        conversationsListNavigationController: UINavigationController,
        themesdNavigationController: UINavigationController,
        profileNavigationController: UINavigationController
    ) {
        self.conversationsListNavigationController = conversationsListNavigationController
        self.themesdNavigationController = themesdNavigationController
        self.profileNavigationController = profileNavigationController
        
        super.init(nibName: nil, bundle: nil)
        
        setupTabBar()
        // loadTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadTheme() {
        ThemeService.shared.loadTheme { [weak self] theme in
            self?.changeTheme(with: theme ?? Theme.light)
        }
    }
    
    private func setupTabBar() {
        tabBar.accessibilityIdentifier = "tabBar"
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true
        tabBar.frame = CGRect(x: -1, y: 0, width: view.frame.width + 1, height: 84)
        
        tabBar.backgroundColor = .systemGray6
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.unselectedItemTintColor = .systemGray
        
        conversationsListNavigationController.tabBarItem = UITabBarItem(
            title: "Channels",
            image: UIImage(systemName: "bubble.left.and.bubble.right"),
            tag: 0
        )
        themesdNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        profileNavigationController.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle"),
            tag: 2
        )
        profileNavigationController.tabBarItem.accessibilityIdentifier = "profileIcon"
        setViewControllers([
            conversationsListNavigationController,
            themesdNavigationController,
            profileNavigationController
        ], animated: false)
    }
    
    private func changeTheme(with theme: Theme) {
        tabBar.backgroundColor = theme == Theme.dark ? .black : .systemGray6
        tabBar.layer.borderColor = theme == Theme.dark ? UIColor.black.cgColor : UIColor.systemGray4.cgColor
        tabBar.unselectedItemTintColor = theme == Theme.dark ? .systemGray6 : .systemGray
    }
}
