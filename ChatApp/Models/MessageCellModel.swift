//
//  MessageCellModel.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//

import UIKit
import TFSChatTransport

struct MessageCellModel: Hashable {
    let id = UUID()
    let message: Message
}

extension Message: Hashable {
    public static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
}
