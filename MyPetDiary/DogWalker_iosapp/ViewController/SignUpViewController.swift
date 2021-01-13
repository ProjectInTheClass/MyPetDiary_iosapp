//
//  SignUpViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
//import Alamofire

struct User: Codable {
    var user_index: Int
    var user_name: String
    var user_token: String
}

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var ref: DatabaseReference! = Database.database().reference()
    
    @IBOutlet weak var nickName: UITextField!
    @IBAction func signUp(_ sender: Any) {
        UserDefaults.standard.setValue(UUID().uuidString, forKey: "token")
        //UserDefaults.standard.setValue(self.nickName, forKey: "nickName")
        guard let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as? MPMainViewController else { return }
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainVC, animated: false)
    
        print("UUID(token) : "+UUID().uuidString)
        
        //self.ref.child("User").child((Auth.auth().currentUser?.uid)!.(["user_index": nickName])
        //self.ref.child("User/\(user.uid)/user_name").setValue(["user_name": nickName])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.nickName.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nickName.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nickName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.nickName.resignFirstResponder()
            return true
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
