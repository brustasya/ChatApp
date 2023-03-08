//
//  MessageCellModel.swift
//  ChatApp
//
//  Created by Станислава on 08.03.2023.
//

import Foundation

struct MessageCellModel: Hashable {
    let text: String
    let date: Date
    let isIncoming: Bool
}
