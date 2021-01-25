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

    @IBOutlet weak var PetDiaryTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fontChange()
        // Do any additional setup after loading the view.
    }
    
    

        func fontChange() {
            TitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 33)
            Title2Label.font = UIFont(name: "Cafe24Oneprettynight", size: 25)
            KeepNextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
            PetDiaryTitle.font = UIFont(name: "SDSamliphopangcheOutline", size: 45)
            
        }
       

   
}

