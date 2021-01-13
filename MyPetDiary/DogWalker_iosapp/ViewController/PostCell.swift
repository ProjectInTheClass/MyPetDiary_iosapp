//
//  PostCell.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/14.
//

import UIKit

class PostCell: UITableViewCell
{
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    
    var post: Post!{
        didSet {
            updateUI()
        }
    }
    
    func updateUI(){
        profileImageView.image = post.createdBy.profileImage
        usernameLabel.text = post.createdBy.username
        postImageView.image = post.image
    }
}
