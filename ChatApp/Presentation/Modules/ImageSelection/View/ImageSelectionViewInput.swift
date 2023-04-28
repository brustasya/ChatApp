//
//  ImageSelectionViewInput.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ImageSelectionViewInput: AnyObject {
    func loadFinished()
    func changeTheme(with theme: Theme)
}
