//
//  TodayMemoViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/18.
//

import UIKit

class TodayMemoViewController: UIViewController {

    static let identifier = "TdMemoViewController"
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var memoContent: UITextView!
    
    var selectedDate: String = ""
    
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    
    // 선택된 날짜
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        if selectedDate == "" {
            cellTitle.text = "\(str)"   //라벨에 출력
        }else{
            cellTitle.text = selectedDate
        }
        
    }
    
    func fontChange() {
        cellTitle.font = UIFont(name: "Cafe24Oneprettynight", size: 20)
        memoContent.font = UIFont(name: "Cafe24Oneprettynight", size: 15)
    }
    
    // image 불러오기
    
    // memo 불러오기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCurrentDateTime()
        fontChange()
        // image 가져오기
        postDataModel
            .showUploadTimeFromDB(deviceToken: deviceToken, selectedDate: selectedDate, completion: {
                uploadTime, isSomething in
                if isSomething {
                    self.petDStorage.loadMemoImage(post_updated_date: uploadTime,
                                                   deviceToken: self.deviceToken,
                                                   selectedDate: self.selectedDate, completion: {
                        image in
                        self.subImageView.image = image
                    })
                } else {
                    self.subImageView.image = nil
                }
                
            })
        
        // content 가져오기
        postDataModel
            .showContentFromDB(deviceToken: deviceToken, selectedDate: selectedDate, completion: {
                content in
                self.memoContent.text = content
            })
    }

}


