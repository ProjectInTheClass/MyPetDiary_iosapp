//
//  PetDFirebaseStorage.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/22.
//

import Firebase
import FirebaseDatabase
import FirebaseStorage

class PetDFirebaseStorage: NSObject {
    static let shared = PetDFirebaseStorage()
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    
    // upload image to storage
    func uploadToStorage(deviceToken: String, receivedPhotoData: NSData, selectedDate: String) {
        // File located on disk
        //let localFile = URL(fileURLWithPath: receivedFilePath)
        
        let storageRef = Storage.storage().reference() // Firebase Storage 객체
        
        // create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Create a reference to the file you want to upload
        let photoDetailRef = storageRef.child("\(selectedDate)+\(deviceToken).jpeg")
        
        let data = receivedPhotoData
        //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        let uploadTask = photoDetailRef.putData(data as Data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          photoDetailRef.downloadURL { (url, error) in
            guard url != nil else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
          // Upload resumed, also fires when the upload starts
        }

        uploadTask.observe(.pause) { snapshot in
          // Upload paused
        }

        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
            _ = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
          // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
              // File doesn't exist
              break
            case .unauthorized:
              // User doesn't have permission to access file
              break
            case .cancelled:
              // User canceled the upload
              break

            /* ... */

            case .unknown:
              // Unknown error occurred, inspect the server response
              break
            default:
              // A separate error occurred. This is a good place to retry the upload.
              break
            }
          }
        }
    }
    
    // upload profile image to storage
    func uploadProfileToStorage(deviceToken: String, receivedPhotoData: NSData, nickname: String) {
        // File located on disk
        //let localFile = URL(fileURLWithPath: receivedFilePath)
        
        let storageRef = Storage.storage().reference() // Firebase Storage 객체
        
        // create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Create a reference to the file you want to upload
        let photoDetailRef = storageRef.child("\(nickname)+\(deviceToken).jpeg")
        
        let data = receivedPhotoData
        //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        let uploadTask = photoDetailRef.putData(data as Data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
            _ = metadata.size
          // You can also access to download URL after upload.
          photoDetailRef.downloadURL { (url, error) in
            guard url != nil else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
          // Upload resumed, also fires when the upload starts
        }

        uploadTask.observe(.pause) { snapshot in
          // Upload paused
        }

        uploadTask.observe(.progress) { snapshot in
          // Upload reported progress
            _ = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
          // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
            switch (StorageErrorCode(rawValue: error.code)!) {
            case .objectNotFound:
              // File doesn't exist
              break
            case .unauthorized:
              // User doesn't have permission to access file
              break
            case .cancelled:
              // User canceled the upload
              break

            /* ... */

            case .unknown:
              // Unknown error occurred, inspect the server response
              break
            default:
              // A separate error occurred. This is a good place to retry the upload.
              break
            }
          }
        }
    }
    
    // load image from storage
    func loadMemoImage(post_updated_date: String, deviceToken: String, selectedDate: String,
                       completion: @escaping (UIImage) -> Void) {
        var imagePath: String = "gs://mypetdiary-475e9.appspot.com/"
        imagePath.append("\(selectedDate)+\(deviceToken).jpeg")
        // Create a reference from a Google Cloud Storage URI
        let gsReference = Storage.storage().reference(forURL: "\(imagePath)")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            let downloadImage = UIImage(data: data!)!
            completion(downloadImage)
          }
        }
    }
    
    // load profile image from storage
    func loadProfileImage(deviceToken: String, nickname: String, completion: @escaping (UIImage) -> Void) {
        var imagePath: String = "gs://mypetdiary-475e9.appspot.com/"
        print("nickname:\(nickname)")
        imagePath.append("\(nickname)+\(deviceToken).jpeg")
        // Create a reference from a Google Cloud Storage URI
        let gsReference = Storage.storage().reference(forURL: "\(imagePath)")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            let downloadImage = UIImage(data: data!)!
            print("다운받은이미지:\(downloadImage)")
            completion(downloadImage)
          }
        }
    }
    
    // get image from download url
    func getProfileImage(downloadURL: String,
                         username: String,
                         content: String,
                         updatedTime: String,
                         completion: @escaping (UIImage, String, String, String) -> Void) {
        
        // Create a reference from a Google Cloud Storage URI
        let gsReference = Storage.storage().reference(forURL: "\(downloadURL)")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error.localizedDescription)
            completion(UIImage(named:"kid-2")!, username, content, updatedTime)
          } else {
            // Data for "images/island.jpg" is returned
            let downloadImage = UIImage(data: data!) ?? UIImage(named: "white")
            completion(downloadImage!, username, content, updatedTime)
          }
        }
    }
    
    func getTwoImage(downloadURL: String,
                     profileImage: UIImage,
                     username: String,
                     content: String,
                     updatedTime: String,
                     completion: @escaping (UIImage, UIImage, String, String, String) -> Void) {
        
        // Create a reference from a Google Cloud Storage URI
        let gsReference = Storage.storage().reference(forURL: "\(downloadURL)")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error.localizedDescription)
          } else {
            let downloadImage = UIImage(data: data!) ?? UIImage(named: "white")
            completion(downloadImage!,profileImage, username, content, updatedTime)
          }
        }
    }
    
    // 마이페이지에서 이미지 배열로 가져오기
    func showImageArray(allImage: Array<String>, completion: @escaping (Array<UIImage>) -> Void) {
        var imgArr: Array<UIImage> = []
        var count: Int = 0
        for index in allImage {
            let gsReference = Storage.storage().reference(forURL: "\(index)")
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            gsReference.getData(maxSize: 20 * 1024 * 1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
              } else {
                let downloadImage = UIImage(data: data!)!
                imgArr.append(downloadImage)
                count += 1
                if count == allImage.count {
                    completion(imgArr)
                }
              }
            }
        }
    }
}
