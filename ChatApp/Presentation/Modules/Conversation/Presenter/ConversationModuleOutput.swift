//
//  ConversationModuleOutput.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ConversationModuleOutput: AnyObject {
    func conversationModuleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?)
}
