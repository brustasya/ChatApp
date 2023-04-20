//
//  UserService.swift
//  ChatApp
//
//  Created by Станислава on 20.04.2023.
//

import Foundation
import UIKit

final class UserService {
    static let shared: UserServiceProtocol = UserService()
    
    private func getId() -> String {
        let userId = UIDevice.current.identifierForVendor?.uuidString

        if let savedUserId = UserDefaults.standard.string(forKey: "userId") {
            print("Saved user ID: \(savedUserId)")
            return savedUserId
        } else {
            UserDefaults.standard.set(userId, forKey: "userId")
            print("New user ID saved: \(userId ?? "")")
            return userId ?? ""
        }
    }
}

extension UserService: UserServiceProtocol {
    func getUserId() -> String {
        return getId()
    }
}
