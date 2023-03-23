//
//  UserProfileGCDDataManager.swift
//  ChatApp
//
//  Created by Станислава on 21.03.2023.
//

import UIKit

protocol ProfileSaver {
    func saveUsername(_ username: String, completion: @escaping (Bool) -> Void)
    func saveDescription(_ description: String, completion: @escaping (Bool) -> Void)
    func saveImage(_ image: UIImage, completion: @escaping (Bool) -> Void)
    
    func loadUserName(completion: @escaping (String?) -> Void)
    func loadDescription(completion: @escaping (String?) -> Void)
    func loadImage(completion: @escaping (UIImage?) -> Void)
    
    func cancel()
}

class GCDProfileSaver: ProfileSaver {
    let queue = DispatchQueue(label: "ru.tinkoff.ProfileSaverQueue")
    let usernameFileURL: URL
    let descriptionFileURL: URL
    let imageFileURL: URL
    let themeFileURL: URL
    
    init(profileDirectory: URL) {
        self.usernameFileURL = profileDirectory.appendingPathComponent("username.txt")
        self.descriptionFileURL = profileDirectory.appendingPathComponent("description.txt")
        self.imageFileURL = profileDirectory.appendingPathComponent("image.json")
        self.themeFileURL = profileDirectory.appendingPathComponent("theme.txt")
    }
    
    func saveTheme(_ theme: Theme, completion: @escaping (Bool) -> Void) {
        queue.async {
            do {
                try theme.rawValue.write(to: self.themeFileURL, atomically: true, encoding: .utf8)
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Error saving theme: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func loadTheme(completion: @escaping (Theme?) -> Void) {
        queue.async {
            do {
                let themeString = try String(contentsOf: self.themeFileURL, encoding: .utf8)
                if let theme = Theme(rawValue: themeString) {
                    DispatchQueue.main.async {
                        completion(theme)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error loading theme: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func saveUsername(_ username: String, completion: @escaping (Bool) -> Void) {
        queue.async {
            do {
                try username.write(to: self.usernameFileURL, atomically: true, encoding: .utf8)
                
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Error saving username: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func saveDescription(_ description: String, completion: @escaping (Bool) -> Void) {
        queue.async {
            do {
                try description.write(to: self.descriptionFileURL, atomically: true, encoding: .utf8)
                
                DispatchQueue.main.async {
                    completion(true)
                }
            } catch {
                print("Error saving description: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        queue.async {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let base64ImageString = imageData.base64EncodedString()
                let imageDict = ["base64": base64ImageString]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: imageDict, options: [])
                    try jsonData.write(to: self.imageFileURL, options: .atomic)
                    
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } catch {
                    print("Error saving image: \(error)")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    
    func loadUserName(completion: @escaping (String?) -> Void) {
        queue.async {
            do {
                let name = try String(contentsOf: self.usernameFileURL, encoding: .utf8)
                DispatchQueue.main.async {
                    completion(name)
                }
            } catch {
                print("Error loading username: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadDescription(completion: @escaping (String?) -> Void) {
        queue.async {
            do {
                let description = try String(contentsOf: self.descriptionFileURL, encoding: .utf8)
                DispatchQueue.main.async {
                    completion(description)
                }
            } catch {
                print("Error loading description: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        queue.async {
            do {
                let jsonData = try Data(contentsOf: self.imageFileURL)
                let imageDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
                if let base64ImageString = imageDict?["base64"] as? String, let imageData = Data(base64Encoded: base64ImageString) {
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            } catch {
                print("Error loading image: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func cancel() {
        queue.suspend()
        queue.async {
            do {
                try FileManager.default.removeItem(at: self.usernameFileURL)
                try FileManager.default.removeItem(at: self.descriptionFileURL)
                try FileManager.default.removeItem(at: self.imageFileURL)
            } catch {
                print("Error canceling profile save: \(error)")
            }
        }
    }
}
