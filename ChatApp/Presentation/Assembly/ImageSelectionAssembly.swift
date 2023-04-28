//
//  ImageSelectionAssembly.swift
//  ChatApp
//
//  Created by Станислава on 28.04.2023.
//

import UIKit

final class ImageSelectionAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeImageSelectionModule(delegate: ImageSelectionDelegate?) -> UIViewController {
        let presenter = ImageSelectionPresenter(
            imageService: serviceAssembly.makeImageService())
        let vc = ImageSelectionViewController(output: presenter)
        presenter.viewInput = vc
        presenter.delegate = delegate
        
        return vc
    }
}
