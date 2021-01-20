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
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var user_nickname: String // 유저 닉네임
    
    init(user_nickname: String) {
        self.user_nickname = user_nickname
    }
    
    convenience override init() {
        self.init(user_nickname: "")
    }
    
    // 마이페이지에서 user_nickname 보이기
    func showUserNickname(deviceToken: String) -> String {
        ref.child("User").child("\(deviceToken)").child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            let userData = FirebaseUserDataModel()
            userData.setValuesForKeys(value! as! [String : Any])
            
            print("user_nickname: \(userData.user_nickname)")
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return user_nickname
    }
}
