//
//  AddPostViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/07.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class AddPostViewController: UIViewController, UITextFieldDelegate {
    
    var contentToDB = "";
    
    //let storage = Storage.storage(url: "gs://mypetdiary-475e9.appspot.com")
    
    let storageRef = Storage.storage().reference() // Firebase Storage 객체
    let postDataModel = FirebasePostDataModel.shared // post DB reference

    @IBOutlet weak var textField: UITextField!
    var receivedPostDate = ""
    var receivedImage = UIImageView() // 이전 페이지 선택이미지
    var receivedImageURL = "" // 이전 페이지 선택 이미지 파일 url
    var receivedWalkSwitch = false // 이전 페이지 산책 스위치
    var receivedWashSwitch = false // 이전 페이지 목욕 스위치
    var receivedMedicineSwitch = false // 이전 페이지 약 스위치
    var receivedHospitalSwitch = false // 이전 페이지 병원 스위치
    var receivedFilePath = "" // 이전 페이지 사진 path
    var receivedPhotoData: NSData? = nil // 넘겨받은 사진 data
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var testView: UIImageView!
    
    // DONE 버튼 눌렀을 경우
    @IBAction func btnSave(_ sender: Any) {
        // 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("글 쓰기 기기 토큰 확인:"+deviceToken)
        
        // 현재 날짜 가져오기
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let current_date_string = formatter.string(from: Date())
        
        // 날짜 데이터 없을 경우 처리
        if receivedPostDate == "" {
            formatter.dateFormat = "yyyy-MM-dd"
            let default_post_date = formatter.string(from: Date())
            receivedPostDate = default_post_date
        }
        
        if textField.text == "" { // textField에 아무것도 안썼을 경우
            // create the alert
            let alert = UIAlertController(title: "내용이 비어있음", message: "글을 작성해주세요", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:nil
            ))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else { // textField에 글을 적었을 경우
        
            // Firebase Storage에 사진 올리기
            // File located on disk
            let localFile = URL(fileURLWithPath: receivedFilePath)
            
            
            // create the file metadata
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("postImage/1")
            
            var data = receivedPhotoData
            //let uploadTask = storageRef.putFile(from: localFile, metadata: metadata)
            let uploadTask = riversRef.putData(data as! Data, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              riversRef.downloadURL { (url, error) in
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
            
            // copy text for DB
            contentToDB = textField.text!
            
            // upload to DB
            postDataModel
                .uploadToDB(deviceToken: deviceToken, selectedDate: receivedPostDate, current_date_string: current_date_string, contentToDB: contentToDB, receivedWalkSwitch: receivedWalkSwitch, receivedWashSwitch: receivedWashSwitch, receivedMedicineSwitch: receivedMedicineSwitch, receivedHospitalSwitch: receivedHospitalSwitch, receivedImageURL: receivedImageURL)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // var receivedImage = UIImageView() // 이전 페이지 선택이미지
        //testView.image = receivedImage.image
        print("산책 스위치 확인: \(receivedWalkSwitch)")
        print("목욕 스위치 확인: \(receivedWashSwitch)")
        print("약 스위치 확인: \(receivedMedicineSwitch)")
        print("병원 스위치 확인: \(receivedHospitalSwitch)")
        
        // 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("글 쓰기 기기 토큰 확인:"+deviceToken)
        
        // 기존에 쓴 글이 있다면 내용 가져오기
        postDataModel
            .showContentFromDB(deviceToken: deviceToken, selectedDate: receivedPostDate, completion: {
                content in
                self.textField.text = content
            })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backtoVC1" {
//            let vc = segue.destination as! ViewController
            
        }
    }
    
    // 화면터치하면 키보드 없어짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.textField.resignFirstResponder()
            self.dismiss(animated: true, completion: nil)
            return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITextViewDelegate
extension AddPostViewController: UITextViewDelegate {
    
    // 메모 textfield의 글자 수를 250자로 제한하기 위해 추가.
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let content = textView.text else { return true }
        
        let limitedLength = content.count + text.count - range.length
        
        return limitedLength <= Config.Appearance.maximumLength
    }
}
