//
//  ProfileModuleOutput.swift
//  ChatApp
//
//  Created by Станислава on 02.05.2023.
//

import Foundation

protocol ProfileModuleOutput: AnyObject {
    func moduleWantsToOpenProfileEditing(
        with profileModel: UserProfileViewModel,
        isPhotoAdded: Bool,
        delegate: ProfileSaveDelegate?
    )
}
