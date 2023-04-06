//
//  ConversationCellModel.swift
//  ChatApp
//
//  Created by Станислава on 06.03.2023.
//

import UIKit
import TFSChatTransport

extension Channel: Hashable {
    public static func == (lhs: Channel, rhs: Channel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
}

struct ChannelModel: Hashable {
    let id = UUID()
    let channel: Channel
}
