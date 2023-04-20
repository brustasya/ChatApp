//
//  ChatDataSourceProtocol.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation

protocol ChatDataSourceProtocol {
    func saveChannelModels(with channelModels: [ChannelModel])
    func saveChannelModel(with channelnModel: ChannelModel)
    func saveMessagesModels(with messageModels: [MessageModel], in channelModel: ChannelModel)
    func saveMessageModel(with messageModel: MessageModel, in channelModel: ChannelModel)
    func deleteChannels(channelModels: [ChannelModel])
    func getAllChannels() -> [ChannelModel]
    func getMessages(for channelUUID: String) -> [MessageModel]
    func deleteChannel(with channelId: String)
}
