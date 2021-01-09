//
//  WithdrawalViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit

class WithdrawalViewController: UIViewController {

    @IBAction func deleteUser(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "backToSetting" {
                let vc = segue.destination as! SettingViewController
            }
        }
        // create the alert
        let alert = UIAlertController(title: "탈퇴 완료", message: "기존 데이터가 삭제되었습니다", preferredStyle: UIAlertController.Style.alert)
        
        // delete userDefaults key value
        UserDefaults.standard.removeObject(forKey: "CustomKey")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "nickName")
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:
                                        { _ in self.goBackToSetting()}
        ))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func keepUser(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            performSegue(withIdentifier: "backToSetting", sender: self)

            if segue.identifier == "backToSetting" {
                let vc = segue.destination as! SettingViewController
            }
        }
    }
    
    func goBackToSetting() {
        performSegue(withIdentifier: "backToSetting", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
