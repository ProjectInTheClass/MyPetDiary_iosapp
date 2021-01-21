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
    
    let storageRef = Storage.storage().reference() // Firebase Storage 객체
    
    func uploadToStorage(current_date_string: String, deviceToken: String, receivedPhotoData: NSData) {
        // File located on disk
        //let localFile = URL(fileURLWithPath: receivedFilePath)
        
        
        // create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        // Create a reference to the file you want to upload
        let photoDetailRef = storageRef.child("\(current_date_string)+\(deviceToken).jpeg")
        
        var data = receivedPhotoData
        //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
        let uploadTask = photoDetailRef.putData(data as! Data, metadata: nil) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          photoDetailRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
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
          let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
        }

        uploadTask.observe(.success) { snapshot in
          // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
          if let error = snapshot.error as? NSError {
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
}
