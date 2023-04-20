//
//  UserProfileDataManager.swift
//  ChatApp
//
//  Created by Станислава on 28.03.2023.
//

import Combine
import UIKit

class UserProfileDataService {
    
    private let userProfileSubject = CurrentValueSubject<UserProfileViewModel?, Never>(nil)
    
    private let fileManager = FileManager.default
    
    private let documentsURL: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            return url
        } else {
            fatalError("Could not create documents directory URL.")
        }
    }()
    
    private let userProfileURL: URL
    
    init() {
        self.userProfileURL = self.documentsURL.appendingPathComponent("userProfile.json")
    }
}

extension UserProfileDataService: UserProfileDataServiceProtocol {
    
    func saveUserProfile(_ userProfile: UserProfileViewModel, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(userProfile)
                try data.write(to: self.userProfileURL)
                self.userProfileSubject.send(userProfile)
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func loadUserProfile() -> AnyPublisher<UserProfileViewModel?, Never> {
        let defaultProfileModel = UserProfileViewModel(
            userName: "No name",
            userDescription: "No bio specified",
            userAvatar: nil)
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: self.userProfileURL) {
                if let userProfile = try? JSONDecoder().decode(UserProfileViewModel.self, from: data) {
                    self.userProfileSubject.send(userProfile)
                } else {
                    self.userProfileSubject.send(defaultProfileModel)
                }
                
            } else {
                self.userProfileSubject.send(defaultProfileModel)
            }
        }
        
        return userProfileSubject.eraseToAnyPublisher()
    }
    
    func cancelSave() {
        DispatchQueue.global(qos: .background).suspend()
    }
}
