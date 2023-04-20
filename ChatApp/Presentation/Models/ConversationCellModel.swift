//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Станислава on 06.03.2023.
//

import UIKit
import TFSChatTransport

struct ChannelModel: Hashable {
    let uuid = UUID()
    let id: String
    let name: String
    let logoURL: String?
    let lastMessage: String?
    let lastActivity: Date?
}
