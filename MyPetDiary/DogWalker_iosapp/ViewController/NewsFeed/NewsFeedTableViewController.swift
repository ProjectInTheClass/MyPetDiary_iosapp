//
//  NewsFeedTableViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/14.
//

import UIKit

class NewsFeedTableViewController: UITableViewController
{
    var posts: [Post]?
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()
    }
    
    func fetchPosts() {
        posts = Post.fetchPosts()
        tableView.reloadData()
    }
}

extension NewsFeedTableViewController
{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        cell.post = posts![indexPath.row]
        return cell
    }





}
