//
//  TFSError.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

enum TFSError: Error {
    case makeRequest
    case noData
    case redirect
    case badRequest
    case serverError
    case unexpectedStatus
}
