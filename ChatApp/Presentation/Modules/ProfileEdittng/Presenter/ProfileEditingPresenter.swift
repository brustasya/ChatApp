//
//  ProfilePresenter.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import Combine

final class ProfileEditingPresenter {
    weak var viewInput: ProfileEditingViewInput?
    weak var moduleOutput: ProfileEditingModuleOutput?
    weak var delegate: ProfileSaveDelegate?
    
    private let profileService: UserProfileDataServiceProtocol
    private let profileModel: UserProfileViewModel
    private var isPhotoAdded: Bool
    
    init(
        profileService: UserProfileDataServiceProtocol,
        moduleOutput: ProfileEditingModuleOutput,
        profileModel: UserProfileViewModel,
        isPhotoAdded: Bool
    ) {
        self.profileService = profileService
        self.moduleOutput = moduleOutput
        self.profileModel = profileModel
        self.isPhotoAdded = isPhotoAdded
    }
    
    private func saveProfile(with userProfileModel: UserProfileViewModel) {
        profileService.saveUserProfile(userProfileModel) { [weak self] (isSaved) in
            if isSaved {
                self?.viewInput?.showSucsessAlert()
                self?.delegate?.profileSaved(with: userProfileModel)
            } else {
                self?.viewInput?.showErrorAlert()
            }
            
            self?.viewInput?.changeEnableForSaving(false)
        }
    }
    
    private func changeTheme() {
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(with: theme)
    }
}

extension ProfileEditingPresenter: ProfileEditingViewOutput {
    func viewIsReady() {
        changeTheme()
        viewInput?.updateProfileData(with: profileModel)
    }
    
    func viewWillAppear() {
        if isPhotoAdded {
            viewInput?.showPhotoAlert()
            isPhotoAdded = false
        }
    }
    
    func saveButtonTapped(profileModel: UserProfileViewModel) {
        viewInput?.changeEnableForSaving(true)
        saveProfile(with: profileModel)
    }
    
    func addPhotoButtonTapped() {
        viewInput?.showPhotoAlert()
    }
    
    func cancelButtonTapped() {
    }
    
    func presentImages(with delegate: ImageSelectionDelegate?) {
        moduleOutput?.moduleWantsToOpenImageSelection(with: delegate)
    }
}
