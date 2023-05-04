//
//  ProfileViewInput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ProfileEditingViewInput: AnyObject {
    func updateProfileData(with profileModel: UserProfileViewModel)
    func changeEnableForSaving(_ isSaving: Bool)
    func showSucsessAlert()
    func showErrorAlert()
    func changeTheme(with theme: Theme)
    func showPhotoAlert() 
}
