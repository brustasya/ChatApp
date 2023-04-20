//
//  ProfileViewInput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ProfileViewInput: AnyObject {
    func updateProfileData(with profileModel: UserProfileViewModel)
    func changeEditEnable(_ isEdittingEnable: Bool)
    func changeEnableForSaving(_ isSaving: Bool)
    func showSucsessAlert()
    func showErrorAlert()
    func changeTheme(with theme: Theme, isEditting: Bool)
    func showPhotoAlert() 
}
