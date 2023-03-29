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
    
    /*enum CodingKeys: String, CodingKey {
        case userName
        case userDescription
        case userAvatar
    }*/

    /*init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        userDescription = try container.decodeIfPresent(String.self, forKey: .userDescription)
        userAvatar = try container.decodeIfPresent(Data.self, forKey: .userAvatar)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userName, forKey: .userName)
        try container.encode(userDescription, forKey: .userDescription)
        try container.encode(userAvatar, forKey: .userAvatar)
    }*/
}
