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
    @IBOutlet weak var thirdTextLabel: UILabel!
    @IBOutlet weak var forthTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fontChange()
    }
    
    func fontChange() {
        CalendarTitleLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        CalendarTextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        thirdTextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        forthTextLabel.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
    }
}
