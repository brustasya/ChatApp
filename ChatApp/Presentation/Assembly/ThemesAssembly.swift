//
//  SettingsAssembly.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit

final class ThemesAssembly {
    private let serviceAssembly: ServiceAssembly

    init(serviceAssembly: ServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func makeSettingsModule() -> UIViewController {
        let presenter = ThemesPresenter()
        let vc = ThemesViewController(output: presenter)
        presenter.viewInput = vc
        
        return vc
    }
}
