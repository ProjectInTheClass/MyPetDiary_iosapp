//
//  FourthIntroViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class FourthIntroViewController: UIViewController {

   
    
    @IBOutlet weak var StartTitleLabel: UILabel!
    
    @IBOutlet weak var RealStartLabel: UILabel!
    
    @IBOutlet weak var StartButton: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fontChange()
    }
    
    func fontChange() {
    
    StartTitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 33)
    RealStartLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 25)
        StartButton.font = UIFont(name: "SDSamliphopangcheOutline", size: 45)
        
    
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
