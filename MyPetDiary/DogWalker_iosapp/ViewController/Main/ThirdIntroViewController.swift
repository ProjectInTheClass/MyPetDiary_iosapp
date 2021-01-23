//
//  ThirdIntroViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class ThirdIntroViewController: UIViewController {

    @IBOutlet weak var ShareTitleLabel: UILabel!
    
    @IBOutlet weak var ShareTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
fontChange()
        
    }
    
    func fontChange() {
        ShareTitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 33)
        ShareTextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 25)
    }
}
