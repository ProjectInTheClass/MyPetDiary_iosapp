//
//  FirebaseUserDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebasePostDataModel: NSObject {
    static let shared = FirebasePostDataModel()
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var post_content: String // 글 내용
    var post_updated_date: String // 글 업로드 시기
    var post_date: String // 글 자체의 날짜
    var post_walk: Bool
    var post_wash: Bool
    var post_medicine: Bool
    var post_hospital: Bool
    
    init(post_content: String, post_updated_date: String, post_date: String,
         post_walk: Bool, post_wash: Bool, post_medicine: Bool, post_hospital: Bool) {
        self.post_content = post_content
        self.post_updated_date = post_updated_date
        self.post_date = post_date
        self.post_walk = post_walk
        self.post_wash = post_wash
        self.post_medicine = post_medicine
        self.post_hospital = post_hospital
    }
    
    convenience override init() {
        self.init(post_content: "", post_updated_date: "", post_date: "",
                  post_walk: false, post_wash: false, post_medicine: false, post_hospital: false)
    }
    
    func showContentFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (Bool, Bool, Bool, Bool) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    //let dic = values as! [String : [String:Any]]
                    for index in value {
                        if let post = index.value as? Dictionary<String, Any> {
                            print(post["post_date"])
                            if post["post_date"] as? String == selectedDate {
                                completion(post["post_walk"] as! Bool, post["post_wash"] as! Bool,
                                           post["post_medicine"] as! Bool, post["post_hospital"] as! Bool)
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
