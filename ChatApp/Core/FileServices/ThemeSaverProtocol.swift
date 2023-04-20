//
//  ThemeSaverProtocol.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ThemeSaverProtocol {
    func saveTheme(_ theme: Theme, completion: @escaping (Bool) -> Void)
    func loadTheme(completion: @escaping (Theme?) -> Void)
}
