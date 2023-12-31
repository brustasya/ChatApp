//
//  UserProfileViewModel.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//

import UIKit

struct UserProfileViewModel: Codable {
    let userName: String?
    let userDescription: String?
    let userAvatar: Data?
}
