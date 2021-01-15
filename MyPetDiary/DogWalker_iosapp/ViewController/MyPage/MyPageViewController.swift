//
//  MyPageViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit

class MyPageViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    // image - db
    var images = [#imageLiteral(resourceName: "mary"), #imageLiteral(resourceName: "hana"), #imageLiteral(resourceName: "dog"), #imageLiteral(resourceName: "dog (1)"), #imageLiteral(resourceName: "ddog")]
    
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
    @IBOutlet weak var userNickName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

//        UserDefaults.standard.value(forKey: "CustomKey") // Load
//        self.userNickName.text = UserDefaults.standard.string(forKey: "nickName")
        
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

//커스텀 셀 구현
class CustomCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
//    imageView.contentMode = .scaleAspectFill
    
}
