//
//  WithdrawalViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit
import Firebase
import FirebaseDatabase

// 탈퇴하기 누른 후 모달
class WithdrawalViewController: UIViewController {
    

    @IBOutlet weak var deleteUser: UIButton!
    
    @IBOutlet weak var keepUser: UIButton!
    
    
    
 
    func updateUI()  {
        deleteUser.layer.cornerRadius = 20
        deleteUser.layer.borderWidth = 2
        deleteUser.layer.borderColor = UIColor.clear.cgColor
        
        keepUser.layer.cornerRadius = 20
        keepUser.layer.borderWidth = 2
        keepUser.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var window: UIWindow?

    // 탈퇴하기 - 예 눌렀을 경우
    @IBAction func deleteUser(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "backToSetting" {
                _ = segue.destination as! SettingViewController
            }
            
        }
        // create the alert
        let alert = UIAlertController(title: "탈퇴 완료", message: "기존 데이터가 삭제되었습니다", preferredStyle: UIAlertController.Style.alert)
        
        // 삭제 전 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("삭제하기 전 저장된 기기토큰 확인:"+deviceToken)
        
        // 디비에서 해당 토큰 정보 삭제
        let deleteUserRef = self.ref.child("User").child("\(deviceToken)")
        deleteUserRef.removeValue()
        let deletePostRef = self.ref.child("Post").child("\(deviceToken)")
        deletePostRef.removeValue()
        let deleteNewsfeedRef = self.ref.child("NewsFeed")
        deleteNewsfeedRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    for index in value.keys {
                        let realDeleteRef = self.ref.child("NewsFeed").child("\(index)").child("\(deviceToken)")
                        realDeleteRef.removeValue()
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // delete userDefaults key value 기기 토큰 삭제
        UserDefaults.standard.removeObject(forKey: "token")
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:
                                        { _ in self.goBackToSignUp()}
        ))
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
        print("삭제 완료")
    }
    
    
    
    // 탈퇴하기 - 아니오 눌렀을 경우
    @IBAction func keepUser(_ sender: Any) {
        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            performSegue(withIdentifier: "backToSetting", sender: self)

            if segue.identifier == "backToSetting" {
                _ = segue.destination as! SettingViewController
            }
        }
    }
    
    // 탈퇴하고 
    func goBackToSignUp() {
        let window = UIApplication.shared.keyWindow!
        let frame = window.rootViewController!.view.frame

        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SignUpView")

        controller.view.frame = frame

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = controller
        }, completion: { completed in
            // maybe do something here
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
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
