//
//  ThemesViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ThemesViewOutput: AnyObject {
    func themeButtonTapped(theme: Theme)
    func viewIsReady()
}
