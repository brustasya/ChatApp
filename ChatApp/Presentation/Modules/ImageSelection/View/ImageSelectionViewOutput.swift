//
//  ImageSelectionViewOutput.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

protocol ImageSelectionViewOutput: AnyObject {
    func viewIsReady()
    func addImage(to cell: ImageCell, at index: Int)
    func imageDidSelect(at index: Int)
    func getCount() -> Int
}
