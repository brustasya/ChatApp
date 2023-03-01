//
//  ViewController.swift
//  ChatApp
//
//  Created by Станислава on 22.02.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileButton()
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    private func setupProfileButton() {
        let profileButton = UIButton()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileButton)
        
        NSLayoutConstraint.activate([
            profileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        profileButton.setTitle("Оpen Profile", for: .normal)
        profileButton.setTitleColor(.systemBlue, for: .normal)
        
        profileButton.addTarget(
            self,
            action: #selector(tapButton),
            for: .touchUpInside
        )
    }
    
    @objc private func tapButton() {
        present(ProfileViewController(), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        Logger.shared.printLog(log: "Called method: \(#function)")
    }
}


