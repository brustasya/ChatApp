//
//  ProfileSaveDelegate.swift
//  ChatApp
//
//  Created by Станислава on 03.05.2023.
//

import Foundation

protocol ProfileSaveDelegate: AnyObject {
    func profileSaved(with profileModel: UserProfileViewModel)
}
