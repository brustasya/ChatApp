//
//  ImageSelectionPresenter.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import Foundation

final class ImageSelectionPresenter {
    weak var viewInput: ImageSelectionViewInput?
    weak var delegate: ImageSelectionDelegate?
    
    private let imageService: ImageServiceProtocol
    
    private lazy var images: [String] = []
    
    init(imageService: ImageServiceProtocol) {
        self.imageService = imageService
    }
    
    private func loadImages() {
        imageService.loadImages { [weak self] result in
            switch result {
            case .success(let imageUrls):
                self?.images = imageUrls
                DispatchQueue.main.async {
                    self?.viewInput?.loadFinished()
                }
            case .failure(let error):
                Logger.shared.printLog(log: "Error loading images: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureCell(with cell: ImageCell, at index: Int) {
        imageService.loadImageData(from: images[index]) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    cell.configure(with: data)
                }
            case .failure(let error):
                Logger.shared.printLog(log: "Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    private func selectImage(at index: Int) {
        let url = images[index]
        imageService.loadImageData(from: url) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.delegate?.imageSelection(didSelectImage: data, url: url)
                }
            case .failure(let error):
                Logger.shared.printLog(log: "Error loading image: \(error.localizedDescription)")
            }
        }
    }
}

extension ImageSelectionPresenter: ImageSelectionViewOutput {
    func viewIsReady() {
        loadImages()
        let theme = ThemeService.shared.getTheme()
        viewInput?.changeTheme(with: theme)
    }
    
    func addImage(to cell: ImageCell, at index: Int) {
        configureCell(with: cell, at: index)
    }
    
    func imageDidSelect(at index: Int) {
        selectImage(at: index)
    }
    
    func getCount() -> Int {
        images.count
    }
}
