//
//  ThemeProtocol.swift
//  ChatApp
//
//  Created by Станислава on 19.04.2023.
//

import Foundation

protocol ThemeServiceProtocol {
    func getTheme() -> Theme
    func setTheme(with theme: Theme)
    func loadTheme(completion: @escaping (Theme?) -> Void)
}
