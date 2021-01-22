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
    
    // 회원가입 시 닉네임 설정& 닉네임 변경
    func saveNickname(deviceToken: String, nickname: String) {
        let userNicknameRef = userRef.child(deviceToken).child("userInfo").child("user_nickname")
        
        userNicknameRef.setValue(nickname)
    }
    
    // 마이페이지에서 소개글 저장하기
    func saveIntro(deviceToken: String, userIntro: String) {
        let userIntroRef = userRef.child("\(deviceToken)").child("userInfo").child("user_intro")
        
        userIntroRef.setValue(userIntro)
    }
    
    // 유저 프로필 사진 등록하기
    func saveProfileImage(deviceToken: String, nickname: String) {
        let userProfileRef = userRef.child("\(deviceToken)").child("userInfo").child("user_profile")
        var imagePath: String = "gs://mypetdiary-475e9.appspot.com/"
        imagePath.append("\(nickname)+\(deviceToken).jpeg")
        userProfileRef.setValue("\(imagePath)")
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
    
    // 소개글 가져오기
    func showIntro(deviceToken: String, completion: @escaping (String) -> Void) {
        userRef.child("\(deviceToken)").child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let value = snapshot.value as? Dictionary<String, String> {
                completion(value["user_intro"] ?? "")
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
