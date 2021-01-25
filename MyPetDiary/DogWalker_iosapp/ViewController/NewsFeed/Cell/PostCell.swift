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
    @IBOutlet weak var showContentTextView: UITextView!
    
    var post: Post!{
        didSet {
            updateUI()
        }
    }
    func imageCircle(){
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.layer.borderWidth = 1
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
    }
    func updateUI(){
        imageCircle()
        profileImageView.image = post.profileImage
        usernameLabel.text = post.username
        postImageView.image = post.image
        showContentTextView.text = post.content
        
        postImageView.clipsToBounds = true
        postImageView.layer.borderWidth = 5
        postImageView.layer.borderColor = UIColor.white.cgColor
        
    }
}
