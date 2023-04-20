//
//  ProfileAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class ProfileAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeProfileModule() -> UIViewController {
        let presenter = ProfilePresenter(
            profileService: serviceAssembly.makeProfileService()
        )
        let vc = ProfileViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}