//
//  Post.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/14.
//

import UIKit


struct FeedUser
{
    var username: String?
    var profileImage: UIImage?
}

struct Post{
    
    var createdBy: FeedUser
    var image: UIImage?
    
    static func fetchPosts() -> [Post]
    {
        var posts = [Post]()
        
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
