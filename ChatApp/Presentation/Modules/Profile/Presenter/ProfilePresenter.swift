//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Станислава on 02.05.2023.
//

import Foundation
import Combine

final class ProfilePresenter {
    weak var viewInput: ProfileViewInput?
    weak var moduleOutput: ProfileModuleOutput?
    private let profileService: UserProfileDataServiceProtocol
    private var profileModel: UserProfileViewModel?
    
    internal lazy var cancellables = Set<AnyCancellable>()

    init(profileService: UserProfileDataServiceProtocol, moduleOutput: ProfileModuleOutput) {
        self.profileService = profileService
        self.moduleOutput = moduleOutput
    }
    
    private func loadProfile() {
        profileService.loadUserProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userProfile in
                let profileModel = UserProfileViewModel(
                    userName: userProfile?.userName,
                    userDescription: userProfile?.userDescription,
                    userAvatar: userProfile?.userAvatar
                )
                
                self?.viewInput?.updateProfile(with: profileModel)
                self?.profileModel = profileModel
            }
            .store(in: &cancellables)
    }
    
    private func changeTheme() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.setupTheme(with: theme)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    func viewIsReady() {
        loadProfile()
    }
    
    func viewWillAppear() {
        changeTheme()
    }
    
    func addPhotoButtonTapped(with delegate: ProfileSaveDelegate?) {
        moduleOutput?.moduleWantsToOpenProfileEditing(
            with: profileModel ?? UserProfileViewModel(userName: "", userDescription: "", userAvatar: nil),
            isPhotoAdded: true,
            delegate: delegate
        )
    }

    func editButtonTapped(with delegate: ProfileSaveDelegate?) {
        moduleOutput?.moduleWantsToOpenProfileEditing(
            with: profileModel ?? UserProfileViewModel(userName: "", userDescription: "", userAvatar: nil),
            isPhotoAdded: false,
            delegate: delegate
        )
    }
    
    func update(with profileModel: UserProfileViewModel) {
        self.profileModel = profileModel
        viewInput?.updateProfile(with: profileModel)
    }
}
