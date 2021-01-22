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
    
    func posts(completion: @escaping ([Post]) -> Void) {
        let result = fetchPosts()
        
        completion(result)
    }
    
    func fetchPosts() -> [Post] {
        var posts = [Post]()
        
        newsfeedDataModel.getTodayFeed(completion: {
            todayPost in
            // todayPost : 오늘 날짜의 게시물 전체 값(배열 형태)
            print(todayPost)
            
            for index in todayPost {
                //posts.append(Post(createdBy: FeedUser(username: index["user_nickname"], profileImage: <#T##UIImage?#>), image: <#T##UIImage?#>), image: )
            }
        })
        
        let Howard = FeedUser(username: "Howard", profileImage: UIImage(named: "hana"))
        
        let Mary = FeedUser(username: "마리언니", profileImage: UIImage(named: "mary"))
        
        let Dongguk = FeedUser(username: "동국이", profileImage: UIImage(named: "ddog"))
        
        let Coders = FeedUser(username: "Coders", profileImage: UIImage(named: "puppy"))
       
        let Kim = FeedUser(username: "Kim", profileImage: UIImage(named: "3"))

        let dream = FeedUser(username: "드림이", profileImage: UIImage(named: "hana"))

        
    
        let post1 = Post(createdBy: Dongguk, image: UIImage(named: "1"))
        let post2 = Post(createdBy: Coders, image: UIImage(named: "2"))
        let post3 = Post(createdBy: Howard, image: UIImage(named: "3"))
       
        let post4 = Post(createdBy: Kim, image: UIImage(named: "4"))
        let post5 = Post(createdBy: dream, image: UIImage(named: "5"))
        let post6 = Post(createdBy: Mary, image: UIImage(named: "6"))
        
        posts.append(post1)
        posts.append(post2)
        posts.append(post3)
        posts.append(post4)
        posts.append(post5)
        posts.append(post6)
        
        return posts
        
    }
}
