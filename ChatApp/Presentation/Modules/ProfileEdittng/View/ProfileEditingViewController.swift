//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Станислава on 18.04.2023.
//

import UIKit
import AVFoundation

class ProfileEditingViewController: UIViewController {
    internal var output: ProfileEditingViewOutput
    
    internal lazy var titleLabel = UILabel()
    internal lazy var editProfileImageView = UIImageView()
    internal lazy var addPhotoButton = UIButton()
    internal lazy var cancelButton = UIButton()
    internal lazy var saveButton = UIButton()
    internal lazy var nameTextField = UITextField()
    internal lazy var nameStackView = UIStackView()
    internal lazy var bioStackView = UIStackView()
    internal lazy var viewNameBackground = UIView()
    internal lazy var viewBioBackground = UIView()
    internal lazy var nameEditLabel = UILabel()
    internal lazy var bioLabel = UILabel()
    internal lazy var bioTextField = UITextField()
    internal lazy var bottomSeparator = UIView()
    internal lazy var topSeparator = UIView()
    internal lazy var centerSeparatop = UIView()
        
    internal let pickerController = UIImagePickerController()
    internal lazy var activityIndicatorView = UIActivityIndicatorView(style: .medium)
    internal lazy var theme = Theme.light
    
    internal let lightTheme = [
        "backgroundColor": UIColor.white,
        "editBackgroundColor": UIColor.systemGray6,
        "textColor": UIColor.black,
        "secondaryTextColor": UIColor.systemGray
    ]
    
    internal let darkTheme = [
        "backgroundColor": #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1),
        "editBackgroundColor": UIColor.black,
        "textColor": UIColor.white,
        "secondaryTextColor": UIColor.systemGray5
    ]
    
    init(output: ProfileEditingViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        output.viewIsReady()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        output.viewWillAppear()
    }
    
    private func setupView() {
        setupTitle()
        setupCancelButton()
        setupSaveButton()
        setupEditProfileImageView()
        setupAddPhotoButton()
        setupEditViews()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicatorView.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
            activityIndicatorView.centerXAnchor.constraint(equalTo: saveButton.centerXAnchor)
        ])
    }
    
    private func setupEditViews() {
        viewNameBackground.backgroundColor = .white
        viewNameBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewNameBackground)
        
        viewBioBackground.backgroundColor = .white
        viewBioBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewBioBackground)
        
        nameEditLabel.text = "Name"
        nameEditLabel.translatesAutoresizingMaskIntoConstraints = false
        viewNameBackground.addSubview(nameEditLabel)
        
        nameTextField.placeholder = "Enter your name"
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameTextField)
        
        bioLabel.text = "Bio"
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        viewBioBackground.addSubview(bioLabel)
        
        bioTextField.placeholder = "Enter your bio"
        bioTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioTextField)
        
        NSLayoutConstraint.activate([
            viewNameBackground.heightAnchor.constraint(equalToConstant: 44),
            viewNameBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewNameBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewNameBackground.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: 24),
            
            viewBioBackground.heightAnchor.constraint(equalToConstant: 44),
            viewBioBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewBioBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewBioBackground.topAnchor.constraint(equalTo: viewNameBackground.bottomAnchor),
            
            nameEditLabel.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor, constant: 16),
            nameEditLabel.widthAnchor.constraint(equalToConstant: 96),
            nameEditLabel.heightAnchor.constraint(equalToConstant: 22),
            nameEditLabel.centerYAnchor.constraint(equalTo: viewNameBackground.centerYAnchor),
            
            bioLabel.leadingAnchor.constraint(equalTo: viewBioBackground.leadingAnchor, constant: 16),
            bioLabel.widthAnchor.constraint(equalToConstant: 96),
            bioLabel.heightAnchor.constraint(equalToConstant: 22),
            bioLabel.centerYAnchor.constraint(equalTo: viewBioBackground.centerYAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: nameEditLabel.trailingAnchor, constant: 8),
            nameTextField.heightAnchor.constraint(equalToConstant: 22),
            nameTextField.centerYAnchor.constraint(equalTo: viewNameBackground.centerYAnchor),
            nameTextField.trailingAnchor.constraint(lessThanOrEqualTo: viewNameBackground.trailingAnchor, constant: -36),
            
            bioTextField.leadingAnchor.constraint(equalTo: bioLabel.trailingAnchor, constant: 8),
            bioTextField.heightAnchor.constraint(equalToConstant: 22),
            bioTextField.centerYAnchor.constraint(equalTo: viewBioBackground.centerYAnchor),
            bioTextField.trailingAnchor.constraint(lessThanOrEqualTo: viewBioBackground.trailingAnchor, constant: -36)
        ])
        
        setupSeparators()
    }
    
    private func setupSeparators() {
        bottomSeparator.backgroundColor = .systemGray5
        topSeparator.backgroundColor = .systemGray5
        centerSeparatop.backgroundColor = .systemGray5
        
        view.addSubview(bottomSeparator)
        view.addSubview(topSeparator)
        view.addSubview(centerSeparatop)
        
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        centerSeparatop.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topSeparator.bottomAnchor.constraint(equalTo: viewNameBackground.topAnchor),
            topSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            topSeparator.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor),
            topSeparator.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor),
            
            bottomSeparator.topAnchor.constraint(equalTo: viewBioBackground.bottomAnchor),
            bottomSeparator.heightAnchor.constraint(equalToConstant: 1.5),
            bottomSeparator.leadingAnchor.constraint(equalTo: viewBioBackground.leadingAnchor),
            bottomSeparator.trailingAnchor.constraint(equalTo: viewBioBackground.trailingAnchor),
            
            centerSeparatop.bottomAnchor.constraint(equalTo: viewNameBackground.bottomAnchor),
            centerSeparatop.heightAnchor.constraint(equalToConstant: 1.5),
            centerSeparatop.leadingAnchor.constraint(equalTo: viewNameBackground.leadingAnchor, constant: 16),
            centerSeparatop.trailingAnchor.constraint(equalTo: viewNameBackground.trailingAnchor)
        ])
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 20),
            saveButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            saveButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
        
        saveButton.addTarget(
            self,
            action: #selector(saveProfileDataButtonTaped),
            for: .touchUpInside
        )
    }
    
    private func setupCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 20),
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            cancelButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16)
        ])
        
        cancelButton.addTarget(
            self,
            action: #selector(dismissController),
            for: .touchUpInside
        )
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        titleLabel.text = "My Profile"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17.0, weight: .semibold)
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 17),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc internal func dismissController() {
        dismiss(animated: true)
    }
    
    private func setupEditProfileImageView() {
        editProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editProfileImageView)
        
        NSLayoutConstraint.activate([
            editProfileImageView.widthAnchor.constraint(equalToConstant: 150),
            editProfileImageView.heightAnchor.constraint(equalToConstant: 150),
            editProfileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 49),
            editProfileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        editProfileImageView.layer.cornerRadius = 75
        editProfileImageView.clipsToBounds = true
        editProfileImageView.contentMode = .scaleAspectFill
    }
    
    private func setupAddPhotoButton() {
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addPhotoButton)
        addPhotoButton.setTitle("Add Photo", for: .normal)
        addPhotoButton.setTitleColor(.systemBlue, for: .normal)
        addPhotoButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        
        NSLayoutConstraint.activate([
            addPhotoButton.widthAnchor.constraint(equalToConstant: 81),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 22),
            addPhotoButton.topAnchor.constraint(equalTo: editProfileImageView.bottomAnchor, constant: 24),
            addPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
    }
    
    @objc private func addPhoto() {
        output.addPhotoButtonTapped()
    }
    
    @objc internal func saveProfileDataButtonTaped() {
        let userProfileModel = UserProfileViewModel(
            userName: nameTextField.text == "" ? "No name" : nameTextField.text,
            userDescription: bioTextField.text == "" ? "No bio specified" : bioTextField.text,
            userAvatar: editProfileImageView.image?.pngData()
        )
        output.saveButtonTapped(profileModel: userProfileModel)
    }
}
