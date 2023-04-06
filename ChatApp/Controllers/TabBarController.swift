//
//  TabBarController.swift
//  ChatApp
//
//  Created by Станислава on 05.04.2023.
//

import UIKit

class TabBarController: UITabBarController {
    private lazy var theme: Theme = .light
    
    let conversationsListViewController = ConversationsListViewController()
    let themesViewController = ThemesViewController()
    let profileViewController = ProfileViewController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupTabBar()
        loadTheme()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadTheme() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let profileSaver = GCDProfileSaver(profileDirectory: documentsDirectory)
        
        profileSaver.loadTheme { [weak self] theme in
            if let theme = theme {
                self?.theme = theme
                self?.updateTheme(theme)
            } else {
                self?.updateTheme(Theme.light)
            }
        }
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemGray6
        tabBar.layer.borderColor = UIColor.systemGray4.cgColor
        tabBar.layer.borderWidth = 0.5
        tabBar.layer.masksToBounds = true
        tabBar.frame = CGRect(x: -1, y: 0, width: view.frame.width + 1, height: 84)
        
        themesViewController.themeChangedHandler = { [weak self] theme in
            self?.theme = theme
            self?.updateTheme(theme)
        }
        
    }
    
    private func updateTheme(_ theme: Theme) {
        self.theme = theme
        themesViewController.configure(with: theme)
        profileViewController.configureTheme(with: theme)
        conversationsListViewController.configure(with: theme)
        
        let conversationsListNavigationController = UINavigationController(rootViewController: conversationsListViewController)
        let themesdNavigationController = UINavigationController(rootViewController: themesViewController)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)

        conversationsListViewController.tabBarItem = UITabBarItem(title: "Channels",
                                                                  image: UIImage(systemName: "bubble.left.and.bubble.right"), tag: 0)
        themesViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle"), tag: 2)
        
        setViewControllers([
            conversationsListNavigationController,
            themesdNavigationController,
            profileNavigationController
        ], animated: false)
        
        tabBar.backgroundColor = theme == Theme.dark ? .black : .systemGray6
        tabBar.layer.borderColor = theme == Theme.dark ? UIColor.black.cgColor : UIColor.systemGray4.cgColor
        tabBar.unselectedItemTintColor = theme == Theme.dark ? .systemGray6 : .systemGray
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let profileSaver = GCDProfileSaver(profileDirectory: documentsDirectory)
        profileSaver.saveTheme(self.theme) { success in
            if success {
                print("Theme saved successfully")
            } else {
                print("Failed to save theme")
            }
        }
    }
}
