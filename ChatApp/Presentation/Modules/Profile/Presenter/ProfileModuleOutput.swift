//
//  ProfileModuleOutput.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ProfileModuleOutput: AnyObject {
    func moduleWantsToOpenImageSelection(with delegate: ImageSelectionDelegate?)
}
