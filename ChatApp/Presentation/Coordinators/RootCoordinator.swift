//
//  RootCoordinator.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class RootCoordinator {
    private weak var window: UIWindow?
    let customTransitionDelegate = CustomTransitionDelegate()

    private let themesAssembly: ThemesAssembly
    private let profileAssembly: ProfileAssembly
    private let profileEditingAssembly: ProfileEditingAssembly
    private let conversationAssembly: ConversationAssembly
    private let conversationsListAssembly: ConversationsListAssembly
    private let imageSelectionAssembly: ImageSelectionAssembly
    private var conversationsListNavigationController: UINavigationController = UINavigationController()
    private var profileNavigationController: UINavigationController = UINavigationController()
    private var conversationViewController: UIViewController = UIViewController()
    private var profileEditingViewController: UIViewController = UIViewController()
    
    init(
        themesAssembly: ThemesAssembly,
        profileAssembly: ProfileAssembly,
        profileEditingAssembly: ProfileEditingAssembly,
        conversationAssembly: ConversationAssembly,
        conversationsListAssembly: ConversationsListAssembly,
        imageSelectionAssembly: ImageSelectionAssembly
    ) {
        self.themesAssembly = themesAssembly
        self.profileAssembly = profileAssembly
        self.profileEditingAssembly = profileEditingAssembly
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
        profileEditingViewController.present(imageSelectionVC, animated: true)
    }
    
    private func openImageSelectionForConversation(with delegate: ImageSelectionDelegate?) {
        let imageSelectionVC = imageSelectionAssembly.makeImageSelectionModule(delegate: delegate)
        conversationViewController.present(imageSelectionVC, animated: true)
    }
    
    private func openProfileEditing(
        with profileModel: UserProfileViewModel, isPhotoAdded: Bool, delegate: ProfileSaveDelegate?
    ) {
        profileEditingViewController = profileEditingAssembly.makeProfileEditingModule(
            moduleOutput: self, profileModel: profileModel, isPhotoAdded: isPhotoAdded, delegate: delegate
        )
        profileEditingViewController.modalPresentationStyle = .custom
        profileEditingViewController.transitioningDelegate = customTransitionDelegate
        profileNavigationController.present(profileEditingViewController, animated: true, completion: nil)
    }
}

extension RootCoordinator: ConversationsListModuleOutput {
    func moduleWantsToOpenConversation(with channel: ChannelModel) {
        openConversation(for: channel)
    }
}

extension RootCoordinator: ProfileEditingModuleOutput {
    func moduleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?) {
        openImageSelection(with: delegate)
    }
}

extension RootCoordinator: ConversationModuleOutput {
    func conversationModuleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?) {
        openImageSelectionForConversation(with: delegate)
    }
}

extension RootCoordinator: ProfileModuleOutput {
    func moduleWantsToOpenProfileEditing(
        with profileModel: UserProfileViewModel,
        isPhotoAdded: Bool,
        delegate: ProfileSaveDelegate?
    ) {
        openProfileEditing(with: profileModel, isPhotoAdded: isPhotoAdded, delegate: delegate)
    }
}
