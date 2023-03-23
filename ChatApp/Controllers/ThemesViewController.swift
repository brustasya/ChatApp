//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Станислава on 13.03.2023.
//

import UIKit

enum Theme : String{
    case light
    case dark
}

class ThemesViewController: UIViewController {

    weak var delegate: ThemesPickerDelegate?
    var themeChangedHandler: ((Theme) -> Void)?
    
    let backgroundView = UIView()
    let lightThemeButton = UIButton()
    let darkThemeButton = UIButton()
    let dayLabel = UILabel()
    let nightLabel = UILabel()
    let lightView = UIView()
    let darkView = UIView()
    
    private let lightTheme = [
        "backgroundColor": UIColor.systemGray6,
        "viewBackgroundColor": UIColor.white,
        "textColor": UIColor.black,
    ]

    private let darkTheme = [
        "backgroundColor": UIColor.black,
        "viewBackgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "textColor": UIColor.white,
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupUI()
    }
    
    private func setupUI() {
        setupNavBar()
        setupBackgroundView()
        setupViews()
        setupMessageViews()
        setupLabels()
        setupButtons()
        
    }
    
    private func setupBackgroundView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.layer.cornerRadius = 10
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 170.38),
            backgroundView.widthAnchor.constraint(equalToConstant: 358),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        navigationItem.title = "Settings"
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    private func setupViews() {
        lightView.backgroundColor = .white
        lightView.layer.cornerRadius = 7
        lightView.layer.masksToBounds = true
        lightView.layer.borderWidth = 0.5
        lightView.layer.borderColor = UIColor.lightGray.cgColor
        lightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lightView)
        
        darkView.backgroundColor = .black
        darkView.layer.cornerRadius = 7
        darkView.layer.masksToBounds = true
        darkView.layer.borderWidth = 0.5
        darkView.layer.borderColor = UIColor.gray.cgColor
        darkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(darkView)
        
        NSLayoutConstraint.activate([
            lightView.heightAnchor.constraint(equalToConstant: 55.38),
            lightView.widthAnchor.constraint(equalToConstant: 79),
            lightView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 50),
            lightView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
            
            darkView.heightAnchor.constraint(equalToConstant: 55.38),
            darkView.widthAnchor.constraint(equalToConstant: 79),
            darkView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -50),
            darkView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 24),
        ])
        
    }
    
    private func setupLabels() {        
        dayLabel.text = "Day"
        dayLabel.font = .systemFont(ofSize: 17)
        dayLabel.isUserInteractionEnabled = true
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lablesTapped)))
        view.addSubview(dayLabel)
        
        nightLabel.text = "Night"
        nightLabel.font = .systemFont(ofSize: 17)
        nightLabel.translatesAutoresizingMaskIntoConstraints = false
        nightLabel.isUserInteractionEnabled = true
        nightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lablesTapped)))
        view.addSubview(nightLabel)
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: lightView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: lightView.bottomAnchor, constant: 10),
            
            nightLabel.centerXAnchor.constraint(equalTo: darkView.centerXAnchor),
            nightLabel.topAnchor.constraint(equalTo: darkView.bottomAnchor, constant: 10),
        ])
    }
    
    private func setupButtons() {
        let imageConfiguration = UIImage.SymbolConfiguration(scale: .large)
        
        lightThemeButton.setImage(
            UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfiguration),
            for: .selected
        )
        lightThemeButton.setImage(
            UIImage(systemName: "circle", withConfiguration: imageConfiguration),
            for: .normal
        )
        lightThemeButton.translatesAutoresizingMaskIntoConstraints = false
        lightThemeButton.addTarget(self, action: #selector(changeThemeButtonTapped), for: .touchUpInside)
        view.addSubview(lightThemeButton)

        darkThemeButton.setImage(
            UIImage(systemName: "checkmark.circle.fill", withConfiguration: imageConfiguration),
            for: .selected
        )
        darkThemeButton.setImage(
            UIImage(systemName: "circle", withConfiguration: imageConfiguration),
            for: .normal
        )
        darkThemeButton.translatesAutoresizingMaskIntoConstraints = false
        darkThemeButton.addTarget(self, action: #selector(changeThemeButtonTapped), for: .touchUpInside)
        view.addSubview(darkThemeButton)
        
        
        
        NSLayoutConstraint.activate([
            lightThemeButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -24),
            lightThemeButton.centerXAnchor.constraint(equalTo: lightView.centerXAnchor),
            
            darkThemeButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -24),
            darkThemeButton.centerXAnchor.constraint(equalTo: darkView.centerXAnchor)
        ])
    }
    
    private func setupMessageViews() {
        let rightMessageViewOnLightView = UIImageView(image: UIImage(named: "sent"))
        rightMessageViewOnLightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightMessageViewOnLightView)
        
        let leftMessageViewOnLightView = UIImageView(image: UIImage(named: "received"))
        leftMessageViewOnLightView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftMessageViewOnLightView)
        
        let rightMessageViewOnDarkView = UIImageView(image: UIImage(named: "sent"))
        rightMessageViewOnDarkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rightMessageViewOnDarkView)
        
        let leftMessageViewOnDarkView = UIImageView(image: UIImage(named: "darkReceived"))
        leftMessageViewOnDarkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(leftMessageViewOnDarkView)
        
        NSLayoutConstraint.activate([
            rightMessageViewOnLightView.heightAnchor.constraint(equalToConstant: 18.19),
            rightMessageViewOnLightView.widthAnchor.constraint(equalToConstant: 51.56),
            rightMessageViewOnLightView.topAnchor.constraint(equalTo: lightView.topAnchor, constant: 7),
            rightMessageViewOnLightView.trailingAnchor.constraint(equalTo: lightView.trailingAnchor, constant: -7),
            
            leftMessageViewOnLightView.heightAnchor.constraint(equalToConstant: 18.19),
            leftMessageViewOnLightView.widthAnchor.constraint(equalToConstant: 51.56),
            leftMessageViewOnLightView.bottomAnchor.constraint(equalTo: lightView.bottomAnchor, constant: -7),
            leftMessageViewOnLightView.leadingAnchor.constraint(equalTo: lightView.leadingAnchor, constant: 7),
            
            rightMessageViewOnDarkView.heightAnchor.constraint(equalToConstant: 18.19),
            rightMessageViewOnDarkView.widthAnchor.constraint(equalToConstant: 51.56),
            rightMessageViewOnDarkView.topAnchor.constraint(equalTo: darkView.topAnchor, constant: 7),
            rightMessageViewOnDarkView.trailingAnchor.constraint(equalTo: darkView.trailingAnchor, constant: -7),
            
            leftMessageViewOnDarkView.heightAnchor.constraint(equalToConstant: 18.19),
            leftMessageViewOnDarkView.widthAnchor.constraint(equalToConstant: 51.56),
            leftMessageViewOnDarkView.bottomAnchor.constraint(equalTo: darkView.bottomAnchor, constant: -7),
            leftMessageViewOnDarkView.leadingAnchor.constraint(equalTo: darkView.leadingAnchor, constant: 7)
        ])
    }

    
    @objc private func changeThemeButtonTapped(_ sender: UIButton) {
        if sender == lightThemeButton {
            lightThemeButton.isSelected = true
            darkThemeButton.isSelected = false
            
            lightThemeButton.tintColor = .systemBlue
            darkThemeButton.tintColor = .lightGray
            
            themeChangedHandler?(Theme.light)
            //delegate?.themesPicker(didSelectTheme: Theme.light)
            
            changeTheme(lightTheme)
        }
        else if sender == darkThemeButton {
            lightThemeButton.isSelected = false
            darkThemeButton.isSelected = true
            
            darkThemeButton.tintColor = .systemBlue
            lightThemeButton.tintColor = .lightGray
            
            themeChangedHandler?(Theme.dark)
            //delegate?.themesPicker(didSelectTheme: Theme.dark)
            
            changeTheme(darkTheme)
        }
    }
    
    func configure(with theme: Theme) {
        if theme == Theme.light {
            lightThemeButton.isSelected = true
            lightThemeButton.tintColor = .systemBlue
            darkThemeButton.isSelected = false
            darkThemeButton.tintColor = .lightGray
            
            changeTheme(lightTheme)
        } else if theme == Theme.dark {
            lightThemeButton.isSelected = false
            lightThemeButton.tintColor = .lightGray
            darkThemeButton.isSelected = true
            darkThemeButton.tintColor = .systemBlue
            
            changeTheme(darkTheme)
        }
    }
    
    private func changeTheme(_ theme: [String: UIColor]) {
        view.backgroundColor = theme["backgroundColor"]
        backgroundView.backgroundColor = theme["viewBackgroundColor"]
        dayLabel.textColor = theme["textColor"]
        nightLabel.textColor = theme["textColor"]
    }
    
    @objc func lablesTapped(_ sender: UITapGestureRecognizer) {
        guard let senderLabel = sender.view as? UILabel else { return }
        if senderLabel == dayLabel {
            lightThemeButton.sendActions(for: .touchUpInside)
        } else if senderLabel == nightLabel {
            darkThemeButton.sendActions(for: .touchUpInside)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}
