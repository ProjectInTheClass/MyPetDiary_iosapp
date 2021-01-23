//
//  SecondIntroViewViewController.swift
//  DogWalker_iosapp
//
//  Created by 김경현 on 2021/01/23.
//

import UIKit

class SecondIntroViewViewController: UIViewController {

    @IBOutlet weak var CalendarTitleLabel: UILabel!
    
    @IBOutlet weak var CalendarTextLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
fontChange()
        
    }
    
    func fontChange() {
        CalendarTitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 33)
        CalendarTextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 25)
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
