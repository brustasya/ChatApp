//
//  ChatDataSource.swift
//  ChatApp
//
//  Created by Станислава on 10.04.2023.
//

import Foundation
import TFSChatTransport

final class ChatDataSource {

    private let coreDataService: CoreDataServiceProtocol = CoreDataService()
    
}

extension ChatDataSource: ChatDataSourceProtocol {

    func saveChannelModels(with channelModels: [ChannelModel]) {
        coreDataService.deleteAllObjects(forEntityName: "DBChannel")
        for channelModel in channelModels {
            saveChannelModel(with: channelModel)
        }
    }
    
    func saveChannelModel(with channelnModel: ChannelModel) {
        coreDataService.save { context in
            let dbChannel = DBChannel(context: context)
            dbChannel.id = channelnModel.id
            dbChannel.lastActivity = channelnModel.lastActivity
            dbChannel.lastMessage = channelnModel.lastMessage
            dbChannel.logoURL = channelnModel.logoURL
            dbChannel.name = channelnModel.name
            if dbChannel.messages == nil {
                dbChannel.messages = NSOrderedSet()
            }
        }
    }
    
    func saveMessagesModels(with messageModels: [MessageModel], in channelModel: ChannelModel) {
        coreDataService.deleteAllMessages(for: channelModel.id)
        coreDataService.save { context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelModel.id as CVarArg)
            guard let dbChannel = try? context.fetch(fetchRequest).first else {
                return
            }
            
            for messageModel in messageModels {
                let dbMessage = DBMessage(context: context)
                dbMessage.uuid = messageModel.uuid
                dbMessage.userName = messageModel.userName
                dbMessage.date = messageModel.date
                dbMessage.userID = messageModel.userID
                dbMessage.text = messageModel.text
                dbChannel.addToMessages(dbMessage)
            }
        }
    }

    func saveMessageModel(with messageModel: MessageModel, in channelModel: ChannelModel) {
        coreDataService.save { context in
            let fetchRequest = DBChannel.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", channelModel.id as CVarArg)
            let dbChannel = try context.fetch(fetchRequest).first

            guard
                let dbChannel
            else {
                return
            }

            let dbMessage = DBMessage(context: context)
            dbMessage.uuid = messageModel.uuid
            dbMessage.userName = messageModel.userName
            dbMessage.date = messageModel.date
            dbMessage.userID = messageModel.userID
            dbMessage.text = messageModel.text
            dbChannel.addToMessages(dbMessage)
        }
    }
    
    func deleteChannels(channelModels: [ChannelModel]) {
        for model in channelModels {
            do {
                try coreDataService.deleteChannel(id: model.id)
            } catch {
                Logger.shared.printLog(log: "Error deleting channel with ID: \(model.id), \(error)")
            }
        }
    }

    func getAllChannels() -> [ChannelModel] {
        do {
            let dbChannel = try coreDataService.fetchChannels()
            let channels: [ChannelModel] = dbChannel.compactMap { dbChannel in
                return ChannelModel(
                    id: dbChannel.id ?? UUID().uuidString,
                    name: dbChannel.name ?? "No name",
                    logoURL: dbChannel.logoURL,
                    lastMessage: dbChannel.lastMessage,
                    lastActivity: dbChannel.lastActivity
                )
            }
            return channels
        } catch {
            Logger.shared.printLog(log: "\(error)")
            return []
        }
    }

    func getMessages(for channelUUID: String) -> [MessageModel] {
        do {
            let dbMessages = try coreDataService.fetchMessages(for: channelUUID)
            let messages: [MessageModel] = dbMessages.compactMap { dbMessage in
                guard
                    let uuid = dbMessage.uuid,
                    let text = dbMessage.text,
                    let userName = dbMessage.userName,
                    let userID = dbMessage.userID,
                    let date = dbMessage.date
                else {
                    return nil
                }

                return MessageModel(
                    uuid: uuid,
                    text: text,
                    userID: userID,
                    userName: userName,
                    date: date
                )
            }

            return messages
        } catch {
            Logger.shared.printLog(log: "\(error)")
            return []
        }
    }
    
    func deleteChannel(with channelId: String) {
        do {
            try coreDataService.deleteChannel(id: channelId)
        } catch {
            Logger.shared.printLog(log: "\(error)")
        }
    }
}
