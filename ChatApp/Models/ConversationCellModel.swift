//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Станислава on 06.03.2023.
//

import Foundation

struct ConversationCellModel: Hashable {
    let name: String
    let message: String?
    let date: Date?
    let isOnline: Bool
    let hasUnreadMessages: Bool
}
