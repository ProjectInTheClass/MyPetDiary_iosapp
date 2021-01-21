//
//  EditProfileViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/21.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editIDTextField: UITextField!
    @IBOutlet weak var editIntroTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

//extension EditProfileViewController : UIImagePickerControllerDelegate,
//UINavigationControllerDelegate{
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        {
//            userImage.image = image
//            print("testImage\(image)")
//        }
//        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
//        let imageName=imageUrl?.lastPathComponent//파일이름
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//
//        let photoURL = NSURL(fileURLWithPath: documentDirectory)
//        print("photoURL\(photoURL)")
//        let localPath = photoURL.appendingPathComponent(imageName!)//파일경로
//        let data=NSData(contentsOf: imageUrl as! URL)!
//        print("lastURL:\(localPath!.path)")
//        //localFile = String(describing: localPath)
//        var str = "file:///"
//        let fileURL = "\(localPath!.path)"
//        str.append(fileURL)
//        localFile = str
//        //localFile = String(decoding: localPath!, as: UTF8.self)
//        print("localFile:"+localFile)
//        dismiss(animated: true, completion: nil)
//
//    }
//}
