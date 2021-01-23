//
//  Post.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/14.
//

import UIKit


struct FeedUser {
    var username: String?
    var profileImage: UIImage?
}

struct Post {
    var createdBy: FeedUser
    var image: UIImage?
}


class PostService {
    static let shared = PostService()
    
    let newsfeedDataModel = FirebaseNewsFeedDataModel.shared // newsfeed DB reference
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    
    func posts(completion: @escaping ([Post]) -> Void) {
        fetchPosts{
            receivedPost in
            print("receivedPost확인!!!!!!!!!!\(receivedPost)")
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
            
            var postCount: Int = 0
            
            for index in todayPost {
                if let postDetail = index as? Dictionary<String, String> {
                    print("index22:\(index)")
                    print("postDetail:\(postDetail)")
                    postContent = postDetail["post_content"] ?? ""
                    username = postDetail["user_nickname"] ?? ""
                    postImage = postDetail["post_image"] ?? ""
                    profileImage = postDetail["user_profile"] ?? ""
                    deviceToken = postDetail["device_token"] ?? ""
                    
                    var profileRealImage: UIImage = UIImage(named: "white")!
                    var contentRealImage: UIImage = UIImage(named: "white")!
                    
                    self.petDStorage.getImage(downloadURL: postImage, completion: {
                        profileUIImage in
                        profileRealImage = profileUIImage
                        self.petDStorage.getImage(downloadURL: postImage, completion: {
                            contentUIImage in
                            contentRealImage = contentUIImage
                            
                            posts.append(Post(createdBy: FeedUser(username: username, profileImage: profileRealImage),
                                              image: contentRealImage))
                            postCount += 1
                            print("post확인:\(posts)")
                            if postCount == todayPost.count {
                                print("마지막이다")
                                completion(posts)
                            }
                        })
                    })
                }
            }
        })
        
//        let Howard = FeedUser(username: "Howard", profileImage: UIImage(named: "hana"))
//
//        let Mary = FeedUser(username: "마리언니", profileImage: UIImage(named: "mary"))
//
//        let Dongguk = FeedUser(username: "동국이", profileImage: UIImage(named: "ddog"))
//
//        let Coders = FeedUser(username: "Coders", profileImage: UIImage(named: "puppy"))
//
//        let Kim = FeedUser(username: "Kim", profileImage: UIImage(named: "3"))
//
//        let dream = FeedUser(username: "드림이", profileImage: UIImage(named: "hana"))
//
//
//
//        let post1 = Post(createdBy: Dongguk, image: UIImage(named: "1"))
//        let post2 = Post(createdBy: Coders, image: UIImage(named: "2"))
//        let post3 = Post(createdBy: Howard, image: UIImage(named: "3"))
//
//        let post4 = Post(createdBy: Kim, image: UIImage(named: "4"))
//        let post5 = Post(createdBy: dream, image: UIImage(named: "5"))
//        let post6 = Post(createdBy: Mary, image: UIImage(named: "6"))
//
//        posts.append(post1)
//        posts.append(post2)
//        posts.append(post3)
//        posts.append(post4)
//        posts.append(post5)
//        posts.append(post6)
//        return posts
        
    }
}
