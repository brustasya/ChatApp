//
//  ThemesPresenter.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

final class ThemesPresenter {
    weak var viewInput: ThemesViewInput?
    
    private func changeTheme(theme: Theme) {
        viewInput?.changeTheme(theme: theme)
    }
}

extension ThemesPresenter: ThemesViewOutput {
    func viewIsReady() {
        let theme = ThemeService.shared.getTheme()
        changeTheme(theme: theme)
    }
    
    func themeButtonTapped(theme: Theme) {
        changeTheme(theme: theme)
        ThemeService.shared.setTheme(with: theme)
    }
}
