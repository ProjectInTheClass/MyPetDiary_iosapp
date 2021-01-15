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
    
    //var ref: FirebaseDatabase.DatabaseReference! = FirebaseDatabase.Database.reference(self: Database)
    var ref: DatabaseReference! = Database.database().reference()
    
//    var ref: DatabaseReference!
//    ref = Database.database().reference()
    
    @IBOutlet weak var nickName: UITextField!
    
    // 회원가입 버튼 눌렀을 경우
    @IBAction func signUp(_ sender: Any, nickName: UITextField) {
        let deviceUniqueToken = UUID().uuidString
        // 기기 정보 기반 토큰 생성하기
        UserDefaults.standard.setValue(deviceUniqueToken, forKey: "token")
        
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? MPMainViewController else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
    
        print("UUID(token) 1: "+deviceUniqueToken)
        print("UUID(token) 2: "+deviceUniqueToken)
        
        
        //self.ref.child("User").child((Auth.auth().currentUser?.uid)!.(["user_index": nickName])
        //self.ref.child("User/\(user.uid)/user_name").setValue(["user_name": nickName])
        
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard let user = authResult?.user else { return }
            let isAnonymous = user.isAnonymous // true
            let uid = user.uid
            print("User's nickName : \(self.nickName.text)")
            
        }
        
        let userRef = self.ref.child("User")
        // let userRef = self.ref.child("User").childByAutoId()
        let userTokenRef = userRef.child(deviceUniqueToken)
        let userNicknameRef = userTokenRef.child("user_nickname")
        
        if let inputNickname = self.nickName.text {
//            let userTokenRef = self.ref.child("User").child("user_token")
//            let userRef = self.ref.child("User").child("user_nickname")
//            userTokenRef.setValue(uniqueToken)
//            userRef.setValue(inputNickName)
            
            userNicknameRef.setValue(inputNickname)
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.nickName.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 사용자가 앱을 끈 경우에도 앞서 계속해서 사용했던 Auth.auth() 객체에 로그인을 한 정보가 쉽게 구현되어 있기 때문에 로그인을 하고 앱을 끄거나 새로 빌드해도 로그인 정보는 남아있음. 이런 점을 이용하여 자동 로그인 구현.
    override func viewWillAppear(_ animated: Bool) {
        self.nickName.becomeFirstResponder()
        
        if let user = Auth.auth().currentUser {
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
