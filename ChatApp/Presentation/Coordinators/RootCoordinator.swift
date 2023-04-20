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
    private var conversationsListNavigationController: UINavigationController = UINavigationController()
    
    init(
        themesAssembly: ThemesAssembly,
        profileAssembly: ProfileAssembly,
        conversationAssembly: ConversationAssembly,
        conversationsListAssembly: ConversationsListAssembly
    ) {
        self.themesAssembly = themesAssembly
        self.profileAssembly = profileAssembly
        self.conversationAssembly = conversationAssembly
        self.conversationsListAssembly = conversationsListAssembly
    }
    
    func start(in window: UIWindow) {
        let rootvC = conversationsListAssembly.makeConversationsListModule(moduleOutput: self)
        self.conversationsListNavigationController = UINavigationController(rootViewController: rootvC)
        
        let tabBarController = TabBarController(
            conversationsListNavigationController: conversationsListNavigationController,
            themesdNavigationController: UINavigationController(rootViewController: themesAssembly.makeSettingsModule()),
            profileNavigationController: UINavigationController(rootViewController: profileAssembly.makeProfileModule())
        )
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func openConversation(for channel: ChannelModel) {
        let conversationVC = conversationAssembly.makeConversationModule(with: channel)
        conversationsListNavigationController.pushViewController(conversationVC, animated: true)
    }
}

extension RootCoordinator: ConversationsListModuleOutput {
    func moduleWantsToOpenConversation(with channel: ChannelModel) {
        openConversation(for: channel)
    }
}
