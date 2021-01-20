//
//  FirebasePostDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebasePostDataModel: NSObject {
    
//    init(post_content: String, post_date: String,
//         post_updated_date: String, post_image: String,
//         post_walk: Bool, post_wash: Bool, post_medicine: Bool, post_hospital: Bool) {
//
//        self.post_content = post_content
//        self.post_date = post_date
//        self.post_updated_date = post_updated_date
//        self.post_image = post_image
//        self.post_walk = post_walk
//        self.post_wash = post_wash
//        self.post_medicine = post_medicine
//        self.post_hospital = post_hospital
//    }
    
//    convenience override init() {
//        self.init(post_content: "", post_date: "",
//                  post_updated_date: "", post_image: "",
//                  post_walk: false, post_wash: false, post_medicine: false, post_hospital: false)
//    }
    
    func showContentPage(deviceToken: String, todayDate: String) -> (post_content: String, post_date: String, post_updated_date: String, post_image: String,
                         post_walk: Bool, post_wash: Bool, post_medicine: Bool, post_hospital: Bool) {
        
        let ref: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        
        var post_content: String = "" // 메모 내용
        var post_date: String = "" // 메모 자체 날짜
        var post_updated_date: String = "" // 메모 최종 업데이트 날짜
        var post_image: String = "" // 사진 url
        var post_walk: Bool = false // 산책 여부
        var post_wash: Bool = false // 목욕 여부
        var post_medicine: Bool = false // 약 여부
        var post_hospital: Bool = false // 병원 여부
        
        ref.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                let values = snapshot.value
                let dic = values as! [String : [String:Any]]
                for index in dic {
                    if (index.value["post_date"] as? String == todayDate) {
                        print(index.key)
                        print(index.value["post_content"] ?? "")
                        print(index.value["post_walk"] ?? false)
                        print(index.value["post_wash"] ?? false)
                        print(index.value["post_medicine"] ?? false)
                        print(index.value["post_hospital"] ?? false)
                        
                        post_walk = index.value["post_walk"] as! Bool
                        post_wash = index.value["post_wash"] as! Bool
                        post_medicine = index.value["post_medicine"] as! Bool
                        post_hospital = index.value["post_hospital"] as! Bool
                    }
                }
            }
        })
        print("test")
        print(post_walk)
        print(post_wash)
        print(post_medicine)
        print(post_hospital)
        return (post_content, post_date, post_updated_date, post_image,
                post_walk, post_wash, post_medicine, post_hospital)
    }
}
