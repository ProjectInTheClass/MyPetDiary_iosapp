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

    @IBOutlet weak var textField: UITextField!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    // DONE 버튼 눌렀을 경우
    @IBAction func btnSave(_ sender: Any) {
        // 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("글 쓰기 기기 토큰 확인:"+deviceToken)
        
        if textField.text == nil {
            // create the alert
            let alert = UIAlertController(title: "내용이 비어있음", message: "글을 작성해주세요", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:nil
            ))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            // copy text for DB
            contentToDB = textField.text!
            
            print("copy Text 확인용:"+contentToDB)
            
            let postRef = self.ref.child("Post")
            let userTokenRef = postRef.child("\(deviceToken)").childByAutoId()
            let postContentRef = userTokenRef.child("post_content")
            
            postContentRef.setValue(contentToDB)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
