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
        
        let Howard = FeedUser(username: "Howard", profileImage: UIImage(named: "Dongguk"))
        
        let post1 = Post(createdBy: Howard, image: UIImage(named: "1"))
        let post2 = Post(createdBy: Howard, image: UIImage(named: "2"))
        let post3 = Post(createdBy: Howard, image: UIImage(named: "3"))
        
        let Mary = FeedUser(username: "Mary", profileImage: UIImage(named: "Hana"))
        
        let post4 = Post(createdBy: Mary, image: UIImage(named: "4"))
        let post5 = Post(createdBy: Mary, image: UIImage(named: "5"))
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
