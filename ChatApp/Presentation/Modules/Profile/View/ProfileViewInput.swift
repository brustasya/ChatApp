//
//  ProfileViewInput.swift
//  ChatApp
//
//  Created by Станислава on 02.05.2023.
//

import Foundation

protocol ProfileViewInput: AnyObject {
    func updateProfile(with model: UserProfileViewModel)
    func setupTheme(with theme: Theme)
}
