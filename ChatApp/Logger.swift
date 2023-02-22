//
//  Logger.swift
//  ChatApp
//
//  Created by Станислава on 22.02.2023.
//

import Foundation

protocol LoggerLogic {
    func printLog(log : String)
}

class Logger : LoggerLogic {
    static let shared = Logger()

    func printLog(log : String) {
        #if DEBUG
            print(log)
        #endif
    }
}
