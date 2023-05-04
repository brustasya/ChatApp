//
//  ImageSelectionDelegate.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ImageSelectionDelegate: AnyObject {
    func imageSelection(didSelectImage data: Data, url: String)
}
