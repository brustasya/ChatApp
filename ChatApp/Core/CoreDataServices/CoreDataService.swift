//
//  CoreDataService.swift
//  ChatApp
//
//  Created by Станислава on 10.04.2023.
//

import Foundation
import CoreData

final class CoreDataService {

    private lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "Chat")
        persistentContainer.loadPersistentStores { _, error in
            guard let error else { return }
            Logger.shared.printLog(log: "Failed to load persistent stores: \(error)")
        }
        Logger.shared.printLog(log: "Persistent stores loaded successfully")
        return persistentContainer
    }()

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}

extension CoreDataService: CoreDataServiceProtocol {

    func fetchChannels() throws -> [DBChannel] {
        let fetchRequest = DBChannel.fetchRequest()
        return try viewContext.fetch(fetchRequest)
    }

    func fetchMessages(for channelUUID: String) throws -> [DBMessage] {
        let fetchRequest = DBChannel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelUUID as CVarArg)
        let dbChannel = try viewContext.fetch(fetchRequest).first

        guard
            let dbChannel,
            let dbMessages = dbChannel.messages?.array as? [DBMessage]
        else {
            Logger.shared.printLog(log: "Error fetching messages for channel with UUID: \(channelUUID)")
            return []
        }

        return dbMessages
    }

    func save(block: @escaping (NSManagedObjectContext) throws -> Void) {
        let backgroundContext = backgroundContext
        backgroundContext.perform {
            do {
                try block(backgroundContext)
                if backgroundContext.hasChanges {
                    try backgroundContext.save()
                    Logger.shared.printLog(log: "Successful save")
                }
            } catch {
                Logger.shared.printLog(log: "Save error: \(error)")
            }
        }
    }
    
    func deleteChannel(id: String) throws {
        let fetchRequest = NSFetchRequest<DBChannel>(entityName: "DBChannel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let privateContext = persistentContainer.newBackgroundContext()
            let dbChannel = try privateContext.fetch(fetchRequest).first
            if let dbChannel = dbChannel {
                privateContext.delete(dbChannel)
                try privateContext.save()
                Logger.shared.printLog(log: "Channel with ID: \(id) deleted successfully")
            } else {
                Logger.shared.printLog(log: "Channel with ID: \(id) not found")
            }
        } catch {
            Logger.shared.printLog(log: "Error deleting channel with ID: \(id), \(error)")
            throw error
        }
    }
    
    func deleteAllObjects(forEntityName entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let backgroundContext = backgroundContext
        do {
            try backgroundContext.execute(deleteRequest)
            try backgroundContext.save()
            Logger.shared.printLog(log: "All \(entityName)s deleted successfully")
        } catch let error as NSError {
            Logger.shared.printLog(log: "Error deleting objects: \(error), \(error.userInfo)")
        }
    }

    func deleteAllMessages(for channelUUID: String) {
        let fetchRequest = NSFetchRequest<DBChannel>(entityName: "DBChannel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", channelUUID as CVarArg)
        
        do {
            let backgroundContext = persistentContainer.newBackgroundContext()
            let dbChannel = try backgroundContext.fetch(fetchRequest).first
            if let dbMessages = dbChannel?.messages?.array as? [DBMessage] {
                dbMessages.forEach { message in
                    backgroundContext.delete(message)
                }
                try backgroundContext.save()
                Logger.shared.printLog(log: "All messages deleted successfully for channel with UUID: \(channelUUID)")
            }
        } catch {
            Logger.shared.printLog(log: "Error deleting messages for channel with UUID: \(channelUUID), \(error)")
        }
    }
}
