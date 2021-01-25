//
//  FourthIntroViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class FourthIntroViewController: UIViewController {
   
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var RealStartLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fontChange()
    }
    
    func fontChange() {
        RealStartLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        startBtn.titleLabel?.font =  UIFont(name: "Cafe24Oneprettynight", size: 20)
    }

}
