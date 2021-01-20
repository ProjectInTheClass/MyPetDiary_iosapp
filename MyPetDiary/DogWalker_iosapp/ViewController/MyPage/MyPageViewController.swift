//
//  MyPageViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyPageViewController: UITableViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var userPicture: UIImageView!
    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var userIntro: UILabel!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var userDataModel: FirebaseUserDataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("마이페이지 기기 토큰 확인:"+deviceToken)
        
        //userNickName.text = userDataModel.showUserNickname(deviceToken: "\(deviceToken)")
//
//        ref.child("User").child("\(deviceToken)").child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let value = snapshot.value as? NSDictionary
//
//            let userData = FirebaseUserDataModel()
//            userData.setValuesForKeys(value! as! [String : Any])
//
//            print("user_nickname: \(userData.user_nickname)")
//
////            let username = value?["user_nickname"] as? String ?? ""
////
////            print("username:"+username)
////
////            self.userNickName.text = username
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//            return CGFloat.leastNonzeroMagnitude
//    }
    
    // image - db
    var images = [#imageLiteral(resourceName: "mary"), #imageLiteral(resourceName: "hana"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "dog (1)"),#imageLiteral(resourceName: "hana"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "dog (1)"), #imageLiteral(resourceName: "ddog"), #imageLiteral(resourceName: "mary"), #imageLiteral(resourceName: "hana"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "dog (1)"),#imageLiteral(resourceName: "hana"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "dog (1)"), #imageLiteral(resourceName: "ddog")]
    
    // collectionview 설정 - 가로3장
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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

class CustomCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}
