//
//  ViewController.swift
//  PosterSession
//
//  Created by EunYoung on 2021/01/13.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var myImage2: UIImageView!
    @IBOutlet weak var feedImage1: UIImageView!
    @IBOutlet weak var feedImage2: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        myImage.layer.cornerRadius = 20
        myImage.clipsToBounds = true
        myImage.layer.borderWidth = 2
        myImage.layer.borderColor = UIColor.lightGray.cgColor
        myImage2.layer.cornerRadius = 20
        myImage2.clipsToBounds = true
        myImage2.layer.borderWidth = 2
        myImage2.layer.borderColor = UIColor.lightGray.cgColor
        
        feedImage1.clipsToBounds = true
        feedImage1.layer.borderWidth = 1
        feedImage1.layer.borderColor = UIColor.lightGray.cgColor
        
        feedImage2.clipsToBounds = true
        feedImage2.layer.borderWidth = 1
        feedImage2.layer.borderColor = UIColor.lightGray.cgColor
        
//        let view = UIView()
//        view.backgroundColor = .white
//        
//        let dogImage = UIImage(named: "dog.jpg")
//        
//        let myImageView: UIImageView = UIImageView()
//        myImageView.contentMode = UIView.ContentMode.scaleAspectFill
//        myImageView.frame.size.width = 300
//        myImageView.frame.size.height = 300
//        myImageView.center = self.view.center
//        
//        myImageView.image = dogImage
//        
//        myImageView.layer.cornerRadius = 100
//        myImageView.clipsToBounds = true
//        myImageView.layer.borderWidth = 10
//        myImageView.layer.borderColor = UIColor.lightGray.cgColor
//        
//        view.addSubview(myImageView)
//        
//        self.view = view
    }
}

