//
//  FirebaseUserDataModel.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/20.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebasePostDataModel: NSObject {
    static let shared = FirebasePostDataModel()
    
    var ref: DatabaseReference! = Database.database().reference()
    
    var post_content: String // 글 내용
    var post_updated_date: String // 글 업로드 시기
    var post_date: String // 글 자체의 날짜
    var post_walk: Bool
    var post_wash: Bool
    var post_medicine: Bool
    var post_hospital: Bool
    
    init(post_content: String, post_updated_date: String, post_date: String,
         post_walk: Bool, post_wash: Bool, post_medicine: Bool, post_hospital: Bool) {
        self.post_content = post_content
        self.post_updated_date = post_updated_date
        self.post_date = post_date
        self.post_walk = post_walk
        self.post_wash = post_wash
        self.post_medicine = post_medicine
        self.post_hospital = post_hospital
    }
    
    convenience override init() {
        self.init(post_content: "", post_updated_date: "", post_date: "",
                  post_walk: false, post_wash: false, post_medicine: false, post_hospital: false)
    }
    
    // get switch value from DB
    func showSwitchFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (Bool, Bool, Bool, Bool, Bool) -> Void) {

        let postDetailRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        
        postDetailRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() { // 기존에 쓴 데이터가 있는 경우 (글 수정)
                if let value = snapshot.value as? Dictionary<String, Any> {
                    completion(value["post_walk"] as! Bool, value["post_wash"] as! Bool,
                               value["post_medicine"] as! Bool, value["post_hospital"] as! Bool, true)
                }
            }
            else {
                let something = false
                completion(false, false, false, false, something)
            }
        })
    }
    
    // upload post to DB
    func uploadToDB(deviceToken: String, selectedDate: String, current_date_string: String,
                    contentToDB: String, receivedWalkSwitch: Bool, receivedWashSwitch: Bool,
                    receivedMedicineSwitch: Bool, receivedHospitalSwitch: Bool,
                    receivedImageURL: String) {
        
        var imagePath: String = "gs://mypetdiary-475e9.appspot.com/"

        let postDetailRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        
        imagePath.append("\(selectedDate)+\(deviceToken).jpeg")
        
        postDetailRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() { // 기존에 쓴 데이터가 있는 경우 (글 수정)
                if let exist = snapshot.value as? [String: Any] {
                    let post = ["post_content": contentToDB, // 글 내용 저장
                                "post_updated_date": exist["post_updated_date"] as Any, // 글 업로드 시기 저장
                                "post_date": selectedDate, // 글 자체의 날짜 저장
                                "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                                "post_wash": receivedWashSwitch,
                                "post_medicine": receivedMedicineSwitch,
                                "post_image": imagePath,
                                "post_hospital": receivedHospitalSwitch] as [String : Any]
    
                     postDetailRef.setValue(post)
                }

            } else {
                // 해당 날짜에 글이 없는 경우(처음 글을 쓰는 경우)
                let post = ["post_content": contentToDB, // 글 내용 저장
                            "post_updated_date": current_date_string, // 글 업로드 시기 저장
                            "post_date": selectedDate, // 글 자체의 날짜 저장
                            "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                            "post_wash": receivedWashSwitch,
                            "post_medicine": receivedMedicineSwitch,
                            "post_image": imagePath,
                            "post_hospital": receivedHospitalSwitch] as [String : Any]

                postDetailRef.setValue(post)
            }
        })
    }
    
    // get content from db
    func showContentFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (String) -> Void) {
        let postDetailRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        
        postDetailRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    completion(value["post_content"] as! String)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // get upload_time from db
    func showUploadTimeFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (String, Bool) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    completion(value["post_updated_date"] as! String, true)
                }
            }
            else {
                let something = false
                completion("", something)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // get post_date from db
    func showPostDateFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (String, Bool) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    completion(value["post_date"] as! String, true)
                }
            }
            else {
                let something = false
                completion("", something)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // download image from storage database
    func showImageFromDB(deviceToken: String, postUpdatedDate: String,
                         completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        // Create a reference from a Google Cloud Storage URI
        let gsRef = storage.reference(forURL: "gs://mypetdiary-475e9.appspot.com/2021-01-21 19:40:41E0A70A86-CD62-4D26-A218-4385A77AC8D0.jpeg")
        
        // Create a reference to the file you want to download
        //let islandRef = storageRef.child("\(postUpdatedDate)\(deviceToken).jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            _ = UIImage(data: data!)
          }
        }
    }
    
    // 캘린더에서 데이터가 있는 모든 날짜 가져오기
    func showAllDate(deviceToken: String, completion: @escaping (Array<String>) -> Void){
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        var strArr: [String] = [] // string 날짜 배열
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    for index in value {
                        strArr.append(index.key)
                    }
                    completion(strArr)
                }
            } else {
                completion(strArr)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // 사용자의 모든 이미지 가져오기(string값)
    func showAllImage(deviceToken: String, completion: @escaping (Array<String>) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        var imgArr: [String] = [] // image url 배열
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    for index in value {
                        if let post = index.value as? Dictionary<String, Any> {
                            imgArr.append(post["post_image"] as! String)
                        }
                    }
                    imgArr.sort(by: { lhs, rhs in
                        return lhs > rhs
                    })
                    completion(imgArr)
                }
            } else {
                completion(imgArr) // 사용자의 이미지에 아무것도 없을 때
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // 개별 포스트 삭제하기
    func deletePost(deviceToken: String, selectedDate: String) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")
        postRef.removeValue()
        
        let postNewsfeedRef: DatabaseReference! = Database.database().reference().child("NewsFeed").child("\(selectedDate)").child("\(deviceToken)")
        postNewsfeedRef.removeValue()
    }
}
