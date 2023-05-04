//
//  ProfileViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ProfileEditingViewOutput: AnyObject {
    func viewIsReady()
    func viewWillAppear()
    func saveButtonTapped(profileModel: UserProfileViewModel)
    func addPhotoButtonTapped()
    func cancelButtonTapped()
    func presentImages(with delegate: ImageSelectionDelegate?)
}
