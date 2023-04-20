//
//  ConversationsListModuleOutput.swift
//  ChatApp
//
//  Created by Станислава on 20.04.2023.
//

import Foundation

protocol ConversationsListModuleOutput: AnyObject {
    func moduleWantsToOpenConversation(with channel: ChannelModel)
}
