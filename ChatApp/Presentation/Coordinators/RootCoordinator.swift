//
//  RootCoordinator.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class RootCoordinator {
    private weak var window: UIWindow?
    
    private let themesAssembly: ThemesAssembly
    private let profileAssembly: ProfileAssembly
    private let conversationAssembly: ConversationAssembly
    private let conversationsListAssembly: ConversationsListAssembly
    private let imageSelectionAssembly: ImageSelectionAssembly
    private var conversationsListNavigationController: UINavigationController = UINavigationController()
    private var profileNavigationController: UINavigationController = UINavigationController()
    private var conversationViewController: UIViewController = UIViewController()
    
    init(
        themesAssembly: ThemesAssembly,
        profileAssembly: ProfileAssembly,
        conversationAssembly: ConversationAssembly,
        conversationsListAssembly: ConversationsListAssembly,
        imageSelectionAssembly: ImageSelectionAssembly
    ) {
        self.themesAssembly = themesAssembly
        self.profileAssembly = profileAssembly
        self.conversationAssembly = conversationAssembly
        self.conversationsListAssembly = conversationsListAssembly
        self.imageSelectionAssembly = imageSelectionAssembly
    }
    
    func start(in window: UIWindow) {
        let conversationsLisRootVC = conversationsListAssembly.makeConversationsListModule(moduleOutput: self)
        self.conversationsListNavigationController = UINavigationController(rootViewController: conversationsLisRootVC)
        
        let profileRootVC = profileAssembly.makeProfileModule(moduleOutput: self)
        self.profileNavigationController = UINavigationController(rootViewController: profileRootVC)
        
        let tabBarController = TabBarController(
            conversationsListNavigationController: conversationsListNavigationController,
            themesdNavigationController: UINavigationController(rootViewController: themesAssembly.makeSettingsModule()),
            profileNavigationController: profileNavigationController
        )
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func openConversation(for channel: ChannelModel) {
        conversationViewController = conversationAssembly.makeConversationModule(with: channel, moduleOutput: self)
        conversationsListNavigationController.pushViewController(conversationViewController, animated: true)
    }
    
    private func openImageSelection(with delegate: ImageSelectionDelegate?) {
        let imageSelectionVC = imageSelectionAssembly.makeImageSelectionModule(delegate: delegate)
        profileNavigationController.present(imageSelectionVC, animated: true)
    }
    
    private func openImageSelectionForConversation(with delegate: ImageSelectionDelegate?) {
        let imageSelectionVC = imageSelectionAssembly.makeImageSelectionModule(delegate: delegate)
        conversationViewController.present(imageSelectionVC, animated: true)
    }
}

extension RootCoordinator: ConversationsListModuleOutput {
    func moduleWantsToOpenConversation(with channel: ChannelModel) {
        openConversation(for: channel)
    }
}

extension RootCoordinator: ProfileModuleOutput {
    func moduleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?) {
        openImageSelection(with: delegate)
    }
}

extension RootCoordinator: ConversationModuleOutput {
    func conversationModuleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?) {
        openImageSelectionForConversation(with: delegate)
    }
}
