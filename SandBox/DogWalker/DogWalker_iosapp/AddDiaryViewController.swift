//
//  AddDiaryViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/05.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos

class AddDiaryViewController: UIViewController{
    
    let picker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func addImage(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)

    }
    
    // picker = UIImagePickerController
    // 사진앨범을 누르면 picker의 소스타입을 사진 라이브러리로
    // 카메라를 누르면 소스타입을 카메라로 지정
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            print("Camera not available")
        }
    }
}

extension AddDiaryViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
//            print(info)
            
        }
        dismiss(animated: true, completion: nil)
      
    }
}
