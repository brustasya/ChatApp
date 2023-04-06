//
//  ProfileViewControllerExtension.swift
//  ChatApp
//
//  Created by Станислава on 04.04.2023.
//

import UIKit
import AVFoundation

extension ProfileViewController {
    @objc internal func disableEditMode() {
        if isSaving {
            // profileSaver?.cancel()
            userProfileDataManager.cancelSave()
            activityIndicatorView.stopAnimating()
            isSaving = false
            saveButton.isHidden = true
        }
        
        isEdittingEnable = false
        isPhotoEdited = false
        changeEditEnable()
    }
    
    @objc internal func enableEditMode() {
        if !isEdittingEnable {
            nameTextField.text = nameLabel.text == "No name" ? "" : nameLabel.text
            bioTextField.text = descriptionLabel.text == "No bio specified" ? "" : descriptionLabel.text
            editProfileImageView.image = profileImageView.image
            isEdittingEnable = true
            changeEditEnable()
            nameTextField.becomeFirstResponder()
        }
    }
    
    @objc internal func addPhoto() {
        enableEditMode()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Сделать фото") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Выбрать из галереи") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(alertController, animated: true)
    }
    
    @objc internal func saveProfileDataButtonTaped() {
        saveButton.isHidden = true
        activityIndicatorView.startAnimating()
        isSaving = true
        nameTextField.isEnabled = false
        bioTextField.isEnabled = false
        addPhotoButton.isEnabled = false
        
        let userProfileModel = UserProfileViewModel(
            userName: nameTextField.text == "" ? "No name" : nameTextField.text,
            userDescription: bioTextField.text == "" ? "No bio specified" : bioTextField.text,
            userAvatar: editProfileImageView.image?.pngData()
        )
        
        userProfileDataManager.saveUserProfile(userProfileModel) { [weak self] (isSaved) in
            if self?.isSaving != nil && self?.isSaving == true {
                if isSaved {
                    let alertController = UIAlertController(title: "Success", message: "You are breathtaking", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                        self?.disableEditMode()
                    }
                    
                    alertController.addAction(okAction)
                    
                    self?.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Could not save profile", message: "Try again", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
                        self?.disableEditMode()
                    }
                    
                    let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] (_) in
                        self?.saveProfileDataButtonTaped()
                    }
                    
                    alertController.addAction(okAction)
                    alertController.addAction(tryAgainAction)
                    
                    self?.present(alertController, animated: true, completion: nil)
                }
                
                self?.saveButton.isHidden = false
            }
            self?.activityIndicatorView.stopAnimating()
            self?.isSaving = false
            self?.nameTextField.isEnabled = true
            self?.bioTextField.isEnabled = true
            self?.addPhotoButton.isEnabled = true
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        editProfileImageView.image = image
        dismiss(animated: true, completion: nil)
    }
    
    internal func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            if type == .camera {
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                
                switch cameraAuthorizationStatus {
                case .authorized:
                    self.present(self.pickerController, animated: true)
                    
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { _ in }
                    
                case .restricted, .denied:
                    let alertController = UIAlertController(
                        title: "Доступ к камере запрещен",
                        message: "Разрешите доступ к камере в настройках приложения",
                        preferredStyle: .alert
                    )
                    
                    let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                    
                    let openSettingsAction = UIAlertAction(title: "Настройки", style: .default) { (_) in
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    alertController.addAction(cancelAction)
                    alertController.addAction(openSettingsAction)
                    
                    present(alertController, animated: true, completion: nil)
                @unknown default:
                    break
                }
            } else {
                self.present(self.pickerController, animated: true)
            }
        }
    }
}
