//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import Combine

final class ProfilePresenter {
    weak var viewInput: ProfileViewInput?
    weak var moduleOutput: ProfileModuleOutput?
    private let profileService: UserProfileDataServiceProtocol
    
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
                
                self?.viewInput?.updateProfileData(with: profileModel)
            }
            .store(in: &cancellables)
    }
    
    private func saveProfile(with userProfileModel: UserProfileViewModel) {
        profileService.saveUserProfile(userProfileModel) { [weak self] (isSaved) in
            if isSaved {
                self?.viewInput?.showSucsessAlert()
                self?.loadProfile()
            } else {
                self?.viewInput?.showErrorAlert()
            }
            
            self?.viewInput?.changeEnableForSaving(false)
        }
    }
    
    private func changeTheme(isEditting: Bool) {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(with: theme, isEditting: isEditting)
    }
    
    private func changeEditEnable(isEnable: Bool) {
        viewInput?.changeEditEnable(isEnable)
        changeTheme(isEditting: isEnable)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    func viewIsReady() {
        loadProfile()
    }
    
    func viewWillAppear() {
        changeTheme(isEditting: false)
    }
    
    func saveButtonTapped(profileModel: UserProfileViewModel) {
        viewInput?.changeEnableForSaving(true)
        saveProfile(with: profileModel)
    }
    
    func addPhotoButtonTapped() {
        changeEditEnable(isEnable: true)
        viewInput?.showPhotoAlert()
    }
    
    func cancelButtonTapped() {
        changeEditEnable(isEnable: false)
    }
    
    func editButtonTapped() {
        changeEditEnable(isEnable: true)
    }
    
    func presentImages(with delegate: ImageSelectionDelegate?) {
        moduleOutput?.moduleWantsToOpenImageSelection(with: delegate)
    }
}
