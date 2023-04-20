//
//  CoreDataServiceProtocol.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol: AnyObject {
    func fetchChannels() throws -> [DBChannel]
    func fetchMessages(for channelUUID: String) throws -> [DBMessage]
    func save(block: @escaping (NSManagedObjectContext) throws -> Void)
    func deleteAllObjects(forEntityName entityName: String)
    func deleteAllMessages(for channelUUID: String)
    func deleteChannel(id: String) throws
}
