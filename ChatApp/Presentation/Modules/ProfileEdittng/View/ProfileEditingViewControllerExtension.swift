//
//  ProfileViewControllerExtension.swift
//  ChatApp
//
//  Created by Станислава on 04.04.2023.
//

import UIKit
import AVFoundation

extension ProfileEditingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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

extension ProfileEditingViewController: ProfileEditingViewInput {
    func updateProfileData(with profileModel: UserProfileViewModel) {
        nameTextField.text = profileModel.userName ?? ""
        bioTextField.text = profileModel.userDescription ?? ""
        
        if nameTextField.text == "No name" { nameTextField.text = "" }
        if bioTextField.text == "No bio specified" { bioTextField.text = "" }
        
        if let imageData = profileModel.userAvatar {
            editProfileImageView.image = UIImage(data: imageData)
        } else {
            editProfileImageView.image = UIImage(named: "avatar")
        }
    }
    
    func changeEnableForSaving(_ isSaving: Bool) {
        if isSaving {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        
        saveButton.isHidden = isSaving
        nameTextField.isEnabled = !isSaving
        bioTextField.isEnabled = !isSaving
        addPhotoButton.isEnabled = !isSaving
    }
    
    func showSucsessAlert() {
        let alertController = UIAlertController(title: "Success", message: "You are breathtaking", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.dismissController()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Could not save profile", message: "Try again", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            self?.dismissController()
        }
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { [weak self] (_) in
            self?.saveProfileDataButtonTaped()
        }
        
        alertController.addAction(okAction)
        alertController.addAction(tryAgainAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func changeTheme(with theme: Theme) {
        let themeColors = theme == Theme.dark ? darkTheme : lightTheme
        
        view.backgroundColor = themeColors["editBackgroundColor"]
        titleLabel.textColor = themeColors["textColor"]
        nameStackView.backgroundColor = themeColors["backgroundColor"]
        bioStackView.backgroundColor = themeColors["backgroundColor"]
        viewBioBackground.backgroundColor = themeColors["backgroundColor"]
        viewNameBackground.backgroundColor = themeColors["backgroundColor"]
        nameTextField.backgroundColor = themeColors["backgroundColor"]
        bioTextField.backgroundColor = themeColors["backgroundColor"]
        nameEditLabel.textColor = themeColors["textColor"]
        bioLabel.textColor = themeColors["textColor"]
        nameTextField.textColor = themeColors["textColor"]
        bioTextField.textColor = themeColors["textColor"]
    }
    
    func showPhotoAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Сделать фото") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Выбрать из галереи") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Загрузить", style: .default, handler: { [weak self] (_) in
            self?.output.presentImages(with: self)
        }))
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(alertController, animated: true)
    }
}

extension ProfileEditingViewController: ImageSelectionDelegate {
    func imageSelection(didSelectImage data: Data, url: String) {
        editProfileImageView.image = UIImage(data: data)
    }
}
