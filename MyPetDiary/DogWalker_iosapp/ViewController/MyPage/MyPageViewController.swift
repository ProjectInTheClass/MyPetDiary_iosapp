//
//  MyPageViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/21.
//

import UIKit
import Firebase
import FirebaseDatabase

class MyPageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var collectionV: UICollectionView!
    @IBAction func backToMyPage (segue : UIStoryboardSegue){}

    @IBOutlet weak var userNickName: UILabel!
    @IBOutlet weak var userInfo: UILabel!
    @IBOutlet weak var userPicture: UIImageView!
    var ref: DatabaseReference! = Database.database().reference()
    var userDataModel = FirebaseUserDataModel.shared // user DB reference
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    
    var images: Array<UIImage> = []
    // 기기 토큰 확인하기
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    
    func imageCircle(){
        userPicture.layer.cornerRadius = userPicture.frame.height / 2
        userPicture.layer.borderWidth = 1
        userPicture.clipsToBounds = true
        userPicture.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
    }
    
    var imgs: Array<UIImage> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageCircle()
        showImage()
        showProfile()
        showNickname()
        showIntro()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        showImage()
        showProfile()
        showNickname()
        showIntro()
    }
    func showNickname(){
        // 닉네임 보이기
        userDataModel
            .showUserNickname(deviceToken: "\(deviceToken)", completion: { nickname in
                self.userNickName.text = nickname
        })
    }
    func showIntro(){
        // 소개글 보이기
        userDataModel
            .showIntro(deviceToken: deviceToken, completion: {
                intro in
                self.userInfo.text = intro
        })
    }
    // 프로필 사진 보여주기
    func showProfile() {
        DispatchQueue.global(qos: .background).async {
            
            DispatchQueue.main.async {
                self.userDataModel.showUserNickname(deviceToken: self.deviceToken, completion: {
                usernickname in
                    self.petDStorage.loadProfileImage(deviceToken: self.deviceToken, nickname: usernickname, completion: { profileImage in
                            self.userPicture.image = profileImage
                            print("img refreshed!!")
                    })
                })
            // Run UI Updates or call completion block
            }
        }
    
    }
    
    // 올린 모든 사진 보이기
    func showImage(){
        postDataModel.showAllImage(deviceToken: deviceToken, completion: { allImage in
            self.petDStorage.showImageArray(allImage: allImage, completion: { newImage in
                self.images = newImage
                self.collectionV.reloadData()
            })
        })
    }
    
    // collectionview 설정 - 이미지 개수 count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    // 이미지 셀 추가
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowCell", for: indexPath) as! CustomCell
        cell.imageView.image = images[indexPath.row]
        return cell
    }
    // view size - 가로 3분할, 가로세로같게
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 3 - 1
        return CGSize(width: width, height: width)
    }
    // 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    // 양옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
}

class CustomCell: UICollectionViewCell{
    @IBOutlet weak var imageView: UIImageView!
}
