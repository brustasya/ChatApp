//
//  MessageCellModel.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//

import UIKit
import TFSChatTransport

struct MessageModel: Hashable {
    let uuid: UUID
    let text: String
    let userID: String
    let userName: String
    let date: Date
}

extension Message: Hashable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
}
