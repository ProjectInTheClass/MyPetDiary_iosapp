//
//  AddPostViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/07.
//

import UIKit
import Firebase
import FirebaseDatabase

class AddPostViewController: UIViewController, UITextFieldDelegate {
    
    var contentToDB = "";
    
    //let storage = Storage.storage()
    var storage = Storage.storage(url: "gs://mypetdiary-475e9.appspot.com")

    @IBOutlet weak var textField: UITextField!
    var receivedPostDate = ""
    var receivedImage = UIImageView() // 이전 페이지 선택이미지
    var receivedImageURL = "http://"
    var receivedWalkSwitch = false // 이전 페이지 산책 스위치
    var receivedWashSwitch = false // 이전 페이지 목욕 스위치
    var receivedMedicineSwitch = false // 이전 페이지 약 스위치
    var receivedHospitalSwitch = false // 이전 페이지 병원 스위치
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var testView: UIImageView!
    var ref: DatabaseReference! = Database.database().reference()
    
    // DONE 버튼 눌렀을 경우
    @IBAction func btnSave(_ sender: Any) {
        // 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("글 쓰기 기기 토큰 확인:"+deviceToken)
        
        // 현재 날짜 가져오기
        let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var current_date_string = formatter.string(from: Date())
        
        if textField.text == nil { // textField에 아무것도 안썼을 경우
            // create the alert
            let alert = UIAlertController(title: "내용이 비어있음", message: "글을 작성해주세요", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:nil
            ))
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
        } else { // textField에 글을 적었을 경우
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
                {
                    receivedImage.image = image
                    print(info)
                    receivedImageURL = info as! String
                }
                dismiss(animated: true, completion: nil)
                
                
            }
            
            // copy text for DB
            contentToDB = textField.text!
            
            print("copy Text 확인용:"+contentToDB)
            
            let postRef = self.ref.child("Post")
        
            let DateRefKey = postRef.child("\(deviceToken)").child("\(receivedPostDate)")
            
            let post = ["post_content": contentToDB, // 글 내용 저장
                        "post_updated_date": current_date_string, // 글 업로드 시기 저장
                        "post_date": receivedPostDate, // 글 자체의 날짜 저장
                        "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                        "post_wash": receivedWashSwitch,
                        "post_medicine": receivedMedicineSwitch,
                        "post_image": receivedImageURL,
                        "post_hospital": receivedHospitalSwitch] as [String : Any]
            
            DateRefKey.setValue(post)
            
            //
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
        
//        ref.child("Post").child("\(deviceToken)").observeSingleEvent(of: .value, with: {(snapshot) in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                if dictionary["post_date"] as! String == showDate {
//                    print(snap.key) // showDate가 들어있는 상위 디렉토리 이름
//                    print(dictionary["post_content"] as? String)
//                }
//            }
//        })
        
        ref.child("Post").child("\(deviceToken)").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                let values = snapshot.value
                let dic = values as! [String : [String:Any]]
                for index in dic {
                    if (index.value["post_date"] as? String == self.receivedPostDate) {
                        print(index.key)
                        print(index.value["post_content"] ?? "")
                        print(index.value["post_walk"] ?? false)
                        print(index.value["post_wash"] ?? false)
                        print(index.value["post_medicine"] ?? false)
                        print(index.value["post_hospital"] ?? false)
                        
                        self.textField.text = index.value["post_content"] as? String
                    }
                }
            }
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
