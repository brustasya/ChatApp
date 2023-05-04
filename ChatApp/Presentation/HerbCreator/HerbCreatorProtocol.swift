//
//  HerbCreatorProtocol.swift
//  ChatApp
//
//  Created by Станислава on 04.05.2023.
//

import Foundation

protocol HerbCreatorProtocol: AnyObject {
    func start(at location: CGPoint)
    func move(to location: CGPoint)
    func stop()
}
