//
//  FirebaseNewsFeedDatabase.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/23.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseNewsFeedDataModel: NSObject {
    static let shared = FirebaseNewsFeedDataModel()
    
    var post_content: String // 글 내용
    var post_updated_date: String // 글 업로드 시기
    var post_date: String // 글 자체의 날짜
    
    init(post_content: String, post_updated_date: String, post_date: String) {
        self.post_content = post_content
        self.post_updated_date = post_updated_date
        self.post_date = post_date
    }
    
    convenience override init() {
        self.init(post_content: "", post_updated_date: "", post_date: "")
    }
    
    // 오늘 날짜 게시물 전체 가져오기
    func getTodayFeed(completion: @escaping (Array<Any>) -> Void) {
        
        var todayPost: Array<Any> = [] // return할 오늘 날짜 게시물 전체
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayDate = formatter.string(from: Date())
        let newsfeedRef: DatabaseReference! = Database.database().reference().child("NewsFeed").child("\(todayDate)")
        
        newsfeedRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() { // 오늘의 게시물이 있다면
                if let value = snapshot.value as? Dictionary<String, Any> {
                    var postCount: Int = 0
                    for index in value {
                        if let news = index.value as? Dictionary<String, Any> {
                            todayPost.append(news)
                            postCount += 1
                            if postCount == value.count {
                                todayPost.sort(by: { lhs, rhs in
                                    if let ldic = lhs as? Dictionary<String, Any>,
                                       let rdic = rhs as? Dictionary<String, Any>,
                                       let lup = ldic["post_updated_date"] as? String,
                                       let rup = rdic["post_updated_date"] as? String{
                                        return lup > rup
                                    } else {
                                        return false
                                    }
                                })
                                completion(todayPost)
                            }
                        }
                    }
                }
            } else { // 오늘의 게시물이 아무것도 없음
                completion(todayPost)
            }
        })
    }
    
    // upload post to DB
    func uploadTodayPost(deviceToken: String, selectedDate: String, current_date_string: String, contentToDB: String, nickname: String) {
        
        let newsfeedRef: DatabaseReference! = Database.database().reference().child("NewsFeed").child("\(selectedDate)").child("\(deviceToken)")
        
        var imagePath: String = "gs://mypetdiary-475e9.appspot.com/"
        var profilePath: String = "gs://mypetdiary-475e9.appspot.com/"
        
        imagePath.append("\(selectedDate)+\(deviceToken).jpeg")
        profilePath.append("\(nickname)+\(deviceToken).jpeg")
        
        newsfeedRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() { // 기존에 쓴 데이터가 있는 경우 (글 수정)
                if let exist = snapshot.value as? [String: Any] {
                    let today = ["device_token": deviceToken, // 글 쓴 사람
                                 "user_nickname": nickname, // 유저 닉네임
                                 "user_profile": profilePath, // 유저 프로필 사진
                                "post_content": contentToDB, // 글 내용 저장
                                "post_updated_date": exist["post_updated_date"] as Any, // 글 업로드 시기 저장
                                "post_date": selectedDate, // 글 자체의 날짜 저장
                                "post_image": imagePath] as [String : Any]
    
                    newsfeedRef.setValue(today)
                }

            } else {
                // 해당 날짜에 글이 없는 경우(처음 글을 쓰는 경우)
                let today = ["device_token": deviceToken, // 글 쓴 사람
                             "user_nickname": nickname, // 유저 닉네임
                             "user_profile": profilePath, // 유저 프로필 사진
                            "post_content": contentToDB, // 글 내용 저장
                            "post_updated_date": current_date_string, // 글 업로드 시기 저장
                            "post_date": selectedDate, // 글 자체의 날짜 저장
                            "post_image": imagePath] as [String : Any]

                newsfeedRef.setValue(today)
            }
        })
    }
    
    
    
}
