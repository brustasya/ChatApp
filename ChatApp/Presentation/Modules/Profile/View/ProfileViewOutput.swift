//
//  ProfileViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 02.05.2023.
//

import Foundation

protocol ProfileViewOutput: AnyObject {
    func viewIsReady()
    func viewWillAppear()
    func addPhotoButtonTapped(with delegate: ProfileSaveDelegate?)
    func editButtonTapped(with delegate: ProfileSaveDelegate?)
    func update(with profileModel: UserProfileViewModel)
}
