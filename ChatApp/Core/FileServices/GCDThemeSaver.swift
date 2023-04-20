//
//  UserProfileGCDDataManager.swift
//  ChatApp
//
//  Created by Станислава on 21.03.2023.
//

import UIKit

class GCDThemeSaver {
    let queue = DispatchQueue(label: "ru.tinkoff.ThemeSaverQueue")
    let themeFileURL: URL
    
    init(profileDirectory: URL) {
        self.themeFileURL = profileDirectory.appendingPathComponent("theme.txt")
    }
}

extension GCDThemeSaver: ThemeSaverProtocol {
    
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
}
