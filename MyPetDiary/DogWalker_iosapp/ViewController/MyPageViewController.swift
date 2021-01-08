//
//  MyPageViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var userNickName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.value(forKey: "CustomKey") // Load
        self.userNickName.text = UserDefaults.standard.string(forKey: "nickName")
        
        // Do any additional setup after loading the view.
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
