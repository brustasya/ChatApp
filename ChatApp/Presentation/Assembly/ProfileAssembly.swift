//
//  ProfileAssembly.swift
//  ChatApp
//
//  Created by Станислава on 03.05.2023.
//

import UIKit

final class ProfileAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeProfileModule(moduleOutput: ProfileModuleOutput) -> UIViewController {
        let presenter = ProfilePresenter(
            profileService: serviceAssembly.makeProfileService(),
            moduleOutput: moduleOutput
        )
        let vc = ProfileViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}
