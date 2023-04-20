//
//  UserProfileDataServiceProtocol.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import Combine

protocol UserProfileDataServiceProtocol {
    func saveUserProfile(_ userProfile: UserProfileViewModel, completion: @escaping (Bool) -> Void)
    func loadUserProfile() -> AnyPublisher<UserProfileViewModel?, Never>
    func cancelSave()
}
