//
//  ThemeService.swift
//  ChatApp
//
//  Created by Станислава on 19.04.2023.
//

import Foundation

class ThemeService {
    private let themeSaver: ThemeSaverProtocol
    private var theme: Theme = Theme.light
    
    static let shared: ThemeServiceProtocol = ThemeService()
    
    init() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Error creating directory")
        }
        
        themeSaver = GCDThemeSaver(profileDirectory: documentsDirectory)
    }
    
    private func saveTheme() {
        themeSaver.saveTheme(self.theme) { success in
            if success {
                Logger.shared.printLog(log: "Theme saved successfully")
            } else {
                Logger.shared.printLog(log: "Failed to save theme")
            }
        }
    }
}

extension ThemeService: ThemeServiceProtocol {
    func getTheme() -> Theme {
        return self.theme
    }
    
    func setTheme(with theme: Theme) {
        self.theme = theme
        saveTheme()
    }
    
    func loadTheme(completion: @escaping (Theme?) -> Void) {
        themeSaver.loadTheme { [weak self] theme in
            if let theme = theme {
                self?.theme = theme
            } else {
                self?.theme = Theme.light
            }
            completion(self?.theme)
        }
    }
}
