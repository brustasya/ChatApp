//
//  OperationProfileSaver.swift
//  ChatApp
//
//  Created by Станислава on 22.03.2023.
//

import UIKit

class OperationProfileSaver: ProfileSaver {
    let queue = OperationQueue()
    let usernameFileURL: URL
    let descriptionFileURL: URL
    let imageFileURL: URL
    
    init(profileDirectory: URL) {
        self.usernameFileURL = profileDirectory.appendingPathComponent("username.txt")
        self.descriptionFileURL = profileDirectory.appendingPathComponent("description.txt")
        self.imageFileURL = profileDirectory.appendingPathComponent("image.json")
    }
    
    func saveUsername(_ username: String, completion: @escaping (Bool) -> Void) {
        let operation = SaveUsernameOperation(username: username, fileURL: usernameFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func saveDescription(_ description: String, completion: @escaping (Bool) -> Void) {
        let operation = SaveDescriptionOperation(description: description, descriptionFileURL: descriptionFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        let operation = SaveImageOperation(image: image, imageFileURL: imageFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadUserName(completion: @escaping (String?) -> Void) {
        let operation = LoadUserNameOperation(usernameFileURL: usernameFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadDescription(completion: @escaping (String?) -> Void) {
        let operation = LoadDescriptionOperation(descriptionFileURL: descriptionFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func loadImage(completion: @escaping (UIImage?) -> Void) {
        let operation = LoadImageOperation(imageURL: imageFileURL, completion: completion)
        queue.addOperation(operation)
    }
    
    func cancel() {
        queue.cancelAllOperations()
    }
}

class SaveUsernameOperation: Operation {
    let username: String
    let fileURL: URL
    let completion: (Bool) -> Void
    
    init(username: String, fileURL: URL, completion: @escaping (Bool) -> Void) {
        self.username = username
        self.fileURL = fileURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        do {
            try username.write(to: fileURL, atomically: true, encoding: .utf8)
            DispatchQueue.main.async {
                self.completion(true)
            }
        } catch {
            print("Error saving username: \(error)")
            DispatchQueue.main.async {
                self.completion(false)
            }
        }
    }
}

class SaveDescriptionOperation: Operation {
    let descriptionText: String
    let descriptionFileURL: URL
    let completion: (Bool) -> Void
    
    init(description: String, descriptionFileURL: URL, completion: @escaping (Bool) -> Void) {
        self.descriptionText = description
        self.descriptionFileURL = descriptionFileURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        do {
            try descriptionText.write(to: descriptionFileURL, atomically: true, encoding: .utf8)
            completion(true)
        } catch {
            print("Error saving description: \(error)")
            completion(false)
        }
    }
}

class SaveImageOperation: Operation {
    let image: UIImage
    let imageFileURL: URL
    let completion: (Bool) -> Void
    
    init(image: UIImage, imageFileURL: URL, completion: @escaping (Bool) -> Void) {
        self.image = image
        self.imageFileURL = imageFileURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let base64ImageString = imageData.base64EncodedString()
            let imageDict = ["base64": base64ImageString]
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: imageDict, options: [])
                try jsonData.write(to: self.imageFileURL, options: .atomic)
                
                completion(true)
            } catch {
                print("Error saving image: \(error)")
                completion(false)
            }
        } else {
            completion(false)
        }
    }
}

class LoadUserNameOperation: Operation {
    let usernameFileURL: URL
    let completion: (String?) -> Void
    
    init(usernameFileURL: URL, completion: @escaping (String?) -> Void) {
        self.usernameFileURL = usernameFileURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        do {
            let name = try String(contentsOf: usernameFileURL, encoding: .utf8)
            completion(name)
        } catch {
            print("Error loading username: \(error)")
            completion(nil)
        }
    }
}

class LoadDescriptionOperation: Operation {
    let descriptionFileURL: URL
    let completion: (String?) -> Void
    
    init(descriptionFileURL: URL, completion: @escaping (String?) -> Void) {
        self.descriptionFileURL = descriptionFileURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        do {
            let description = try String(contentsOf: descriptionFileURL, encoding: .utf8)
            completion(description)
        } catch {
            print("Error loading description: \(error)")
            completion(nil)
        }
    }
}

class LoadImageOperation: Operation {
    let imageURL: URL
    let completion: (UIImage?) -> Void
    
    init(imageURL: URL, completion: @escaping (UIImage?) -> Void) {
        self.imageURL = imageURL
        self.completion = completion
        super.init()
    }
    
    override func main() {
        if isCancelled {
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: imageURL)
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            
            if let imageDict = json as? [String: String],
                let base64ImageString = imageDict["base64"],
                let imageData = Data(base64Encoded: base64ImageString),
                let image = UIImage(data: imageData) {
                completion(image)
            } else {
                completion(nil)
            }
        } catch {
            print("Error loading image: \(error)")
            completion(nil)
        }
    }
}
