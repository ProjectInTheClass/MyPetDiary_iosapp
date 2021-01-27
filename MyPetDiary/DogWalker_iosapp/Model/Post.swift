//
//  Post.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/14.
//

import UIKit

struct Post {
    var username: String?
    var profileImage: UIImage?
    var image: UIImage?
    var content: String?
    var updatedTime: String?
}


class PostService {
    static let shared = PostService()
    
    let newsfeedDataModel = FirebaseNewsFeedDataModel.shared // newsfeed DB reference
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    
    func posts(completion: @escaping ([Post]) -> Void) {
        fetchPosts{
            receivedPost in
            completion(receivedPost)
        }
    }
    
    func fetchPosts(completion: @escaping ([Post]) -> Void) {
        
        var posts = [Post]()
        
        newsfeedDataModel.getTodayFeed(completion: {
            todayPost in
            // todayPost : 오늘 날짜의 게시물 전체 값(배열 형태)
            
            var postContent: String = "" // 받아올 내용
            var username: String = "" // 받아올 유저 이름
            var postImage: String = "" // 받아올 내용 이미지 다운로드 url
            var profileImage: String = "" // 받아올 프로필 이미지 다운로드 url
            var deviceToken: String = "" // 받아올 유저 디바이스 토큰
            var updatedTime: String = "" // 받아올 번역
            
            var postCount: Int = 0
            
            var serverflag: Int = 0 // 서버 확인용 flag
            
            if todayPost.count != 0 { // 오늘의 게시물이 있는 경우
                for index in todayPost {
                    if let postDetail = index as? Dictionary<String, String> {
                        postContent = postDetail["post_content"] ?? ""
                        username = postDetail["user_nickname"] ?? ""
                        postImage = postDetail["post_image"] ?? ""
                        profileImage = postDetail["user_profile"] ?? ""
                        deviceToken = postDetail["device_token"] ?? ""
                        updatedTime = postDetail["post_updated_date"] ?? ""
                        
                        self.petDStorage.getProfileImage(downloadURL: profileImage,
                                                         username: username,
                                                         content: postContent,
                                                         updatedTime: updatedTime,
                                                         completion: {
                            profileUIImage, username, postContent, updatedTime in
                            postImage = postDetail["post_image"] ?? ""
                            self.petDStorage.getTwoImage(downloadURL: postImage,
                                                         profileImage: profileUIImage,
                                                         username: username,
                                                         content: postContent,
                                                         updatedTime: updatedTime,
                                                         completion: {
                                contentUIImage,profileUIImage, username, postContent, updatedTime  in
                                posts.append(Post(username: username,
                                                  profileImage: profileUIImage,
                                                  image: contentUIImage,
                                                  content: postContent,
                                                  updatedTime: updatedTime))
                                postCount += 1
                                                            serverflag += 1
                                if postCount == todayPost.count {
                                    posts.sort(by: { lhs, rhs in
                                         if let lup = lhs.updatedTime,
                                            let rup = rhs.updatedTime {
                                            return lup > rup
                                        } else {
                                            return false
                                        }
                                    })
                                    if serverflag == 0 {
                                        // 서버 초과되서 안나올 경우
                                        posts = [Post]()
                                        posts.append(Post(username: "",
                                                          profileImage: UIImage(named: "white"),
                                                          image: UIImage(named: "server"),
                                                          content: ""))
                                        completion(posts)
                                    }
                                    completion(posts)
                                }
                            })
                        })
                    }
                }
            } else { // 오늘의 게시물이 없는 경우
                posts = [Post]()
                posts.append(Post(username: "",
                                  profileImage: UIImage(named: "white"),
                                  image: UIImage(named: "nothing"),
                                  content: "오늘의 petD를 작성해보세요!"))
                completion(posts)
            }
        })
    }
}
