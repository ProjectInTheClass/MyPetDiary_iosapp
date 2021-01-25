//
//  FourthIntroViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class FourthIntroViewController: UIViewController {

   
    @IBOutlet weak var LastLabel: UILabel!
    
    @IBOutlet weak var StartTitleLabel: UILabel!
    
    @IBOutlet weak var RealStartLabel: UILabel!
    
    @IBOutlet weak var StartButton: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fontChange()
    }
    
    func fontChange() {
        
        LastLabel.font = UIFont(name: "SDSamliphopangcheBasic", size: 40)
        
    
    StartTitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 33)
    RealStartLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 25)
        StartButton.font = UIFont(name: "SDSamliphopangcheOutline", size: 45)
        
    
    }
    
    
    @IBAction func ButtonTapped(_ sender: Any) {
        
        StartButton.font = UIFont(name: "SDSamliphopangcheBasic", size: 45)
        
        StartButton.textColor = UIColor.darkGray
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
