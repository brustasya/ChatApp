//
//  ConversationViewInput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ConversationViewInput: AnyObject {
    func update(with messages: [MessageModel])
    func changeTheme(_ theme: Theme)
    func clearMessageTextField()
    func setupNavigationBarContent(logoURL: Data, name: String)
    func setupUserId(userId: String)
    func showAlert()
    func reloadTable()
}
