//
//  ConversationsListViewInput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ConversationsListViewInput: AnyObject {
    func applySnapshot(with channels: [ChannelModel])
    func stopRefreshing()
    func changeTheme(theme: Theme)
    func showAlert()
}
