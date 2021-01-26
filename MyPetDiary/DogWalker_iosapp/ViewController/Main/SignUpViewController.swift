//
//  SignUpViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
//import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var nickName: UITextField!
    
    func fontChange() {
        firstLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 16)
    }
    var userDataModel = FirebaseUserDataModel.shared // user DB reference
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = nickName.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
     
        return updatedText.count <= 10
    }
    // 회원가입 버튼 눌렀을 경우
    @IBAction func signUp(_ sender: Any, nickName: UITextField) {
        
        if self.nickName.text == "" { // 닉네임을 입력하지 않았을 경우 alert
            // create the alert
            let alert = UIAlertController(title: "닉네임 필수 입력", message: "닉네임 입력 후 사용이 가능합니다", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:nil
            ))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else if self.nickName.text == "admin" {
            
            UserDefaults.standard.setValue("deviceToken-admin", forKey: "token")
            
            userDataModel.saveNickname(deviceToken: "deviceToken-admin", nickname: "admin")
            
            guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? MPMainViewController else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
        }
        else {
            // 기기 정보 기반 토큰 생성하기
            let deviceToken = UUID().uuidString
            UserDefaults.standard.setValue(deviceToken, forKey: "token")
            
            userDataModel.saveNickname(deviceToken: deviceToken, nickname: self.nickName.text!)
            
            guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? MPMainViewController else { return }
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
            
            
        }
        
        //self.ref.child("User").child((Auth.auth().currentUser?.uid)!.(["user_index": nickName])
        //self.ref.child("User/\(user.uid)/user_name").setValue(["user_name": nickName])
        
//        Auth.auth().signInAnonymously() { (authResult, error) in
//            guard let user = authResult?.user else { return }
//            let isAnonymous = user.isAnonymous // true
//            let uid = user.uid
//            print("User's nickName : \(self.nickName.text)")
//            
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.nickName.delegate = self
        fontChange()
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 사용자가 앱을 끈 경우에도 앞서 계속해서 사용했던 Auth.auth() 객체에 로그인을 한 정보가 쉽게 구현되어 있기 때문에 로그인을 하고 앱을 끄거나 새로 빌드해도 로그인 정보는 남아있음. 이런 점을 이용하여 자동 로그인 구현.
    override func viewWillAppear(_ animated: Bool) {
        self.nickName.becomeFirstResponder()
        
        if Auth.auth().currentUser != nil {
            guard let dvc = self.storyboard?.instantiateViewController(identifier: "MainView") as? ViewController else {
                return
            }
            self.present(dvc, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nickName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.nickName.resignFirstResponder()
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
