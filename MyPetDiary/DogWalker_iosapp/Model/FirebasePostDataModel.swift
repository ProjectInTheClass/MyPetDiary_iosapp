//
//  FirebasePostDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase

class FirebasePostDataModel: NSObject {
    var ref: DatabaseReference
    
    var post_content: String // 메모 내용
    var post_date: String // 메모 자체 날짜
    var post_updated_date: String // 메모 최종 업데이트 날짜
    var post_image: String // 사진 url
    var post_walk: Bool // 산책 여부
    var post_wash: Bool // 목욕 여부
    var post_medicine: Bool // 약 여부
    var post_hospital: Bool // 병원 여부
    
    init(post_content: String, post_date: String,
         post_updated_date: String, post_image: String,
         post_walk: Bool, post_wash: Bool, post_medicine: Bool, post_hospital: Bool) {
        
        
    }
    
    func 
}
