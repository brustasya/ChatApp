//
//  ConversationsListViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import Combine
import TFSChatTransport

protocol ConversationsListViewOutput: AnyObject {
    func viewIsReady()
    func viewWillAppear()
    func reloadData()
    func addChannel(name: String)
    func addChannelButtonTapped()
    func channelDeleted(at indexPath: IndexPath)
    func channelDidSelect(at indexPath: IndexPath)
}
