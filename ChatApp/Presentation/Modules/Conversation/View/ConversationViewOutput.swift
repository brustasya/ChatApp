//
//  ConversationViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ConversationViewOutput: AnyObject {
    func viewIsReady()
    func sendMessage(with text: String)
}
