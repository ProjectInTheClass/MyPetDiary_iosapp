//
//  FirebaseUserDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseUserDataModel: NSObject {
    static let shared = FirebaseUserDataModel()
    
    var userRef: DatabaseReference! = Database.database().reference().child("User")
    
    var user_nickname: String // 유저 닉네임
    
    init(user_nickname: String) {
        self.user_nickname = user_nickname
    }
    
    convenience override init() {
        self.init(user_nickname: "")
    }
    
    // 회원가입
    func signUpFirst(deviceToken: String, nickname: String) {
        let userNicknameRef = userRef.child(deviceToken).child("userInfo").child("user_nickname")
        
        userNicknameRef.setValue(nickname)
    }
    
    // 마이페이지에서 user_nickname 보이기
    func showUserNickname(deviceToken: String, completion: @escaping (String) -> Void) {
        userRef.child("\(deviceToken)").child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, String> {
                completion(value["user_nickname"] ?? "")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // 마이페이지에서 소개글 저장하기
    func saveIntro(deviceToken: String, userIntro: String) {
        let userIntroRef = userRef.child("\(deviceToken)").child("userInfo").child("user_intro")
        
        userIntroRef.setValue(userIntro)
    }
}
