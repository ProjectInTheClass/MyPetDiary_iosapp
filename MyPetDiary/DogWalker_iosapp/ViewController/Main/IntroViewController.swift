//
//  IntroViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class IntroViewController: UIViewController {

    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var Title2Label: UILabel!
    @IBOutlet weak var KeepNextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontChange()
    }
    
    func fontChange() {
        TitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        Title2Label.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        KeepNextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
    }
}

