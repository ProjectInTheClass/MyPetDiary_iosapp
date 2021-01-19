//
//  FirebaseUserDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase

class FirebaseUserDataModel: NSObject {
    
    var user_nickname: String // 유저 닉네임
    
    init(user_nickname: String) {
        
        self.user_nickname = user_nickname
    }
    
    convenience override init() {
        self.init(user_nickname: "")
    }
}
