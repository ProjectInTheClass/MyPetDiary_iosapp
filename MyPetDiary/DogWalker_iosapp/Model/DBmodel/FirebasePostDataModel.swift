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
                           completion: @escaping (Bool, Bool, Bool, Bool) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    //let dic = values as! [String : [String:Any]]
                    for index in value {
                        if let post = index.value as? Dictionary<String, Any> {
                            if post["post_date"] as? String == selectedDate {
                                completion(post["post_walk"] as! Bool, post["post_wash"] as! Bool,
                                           post["post_medicine"] as! Bool, post["post_hospital"] as! Bool)
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // upload post to DB
    func uploadToDB(deviceToken: String, selectedDate: String, current_date_string: String,
                    contentToDB: String, receivedWalkSwitch: Bool, receivedWashSwitch: Bool,
                    receivedMedicineSwitch: Bool, receivedHospitalSwitch: Bool,
                    receivedImageURL: String) {
        
        let postRef: DatabaseReference! =
            Database.database().reference().child("Post").child("\(deviceToken)")

        let postDetailRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)").child("\(selectedDate)")

//        let post = ["post_content": contentToDB, // 글 내용 저장
//                    "post_updated_date": current_date_string, // 글 업로드 시기 저장
//                    "post_date": selectedDate, // 글 자체의 날짜 저장
//                    "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
//                    "post_wash": receivedWashSwitch,
//                    "post_medicine": receivedMedicineSwitch,
//                    "post_image": receivedImageURL,
//                    "post_hospital": receivedHospitalSwitch] as [String : Any]
//
//        postDetailRef.setValue(post)
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    for index in value {
                        if index.key == "\(selectedDate)" { // 기존에 저장한 내용이 있는 경우
                            let post = ["post_content": contentToDB, // 글 내용 저장
                                        //"post_updated_date": current_date_string, // 글 업로드 시기 저장
                                        "post_date": selectedDate, // 글 자체의 날짜 저장
                                        "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                                        "post_wash": receivedWashSwitch,
                                        "post_medicine": receivedMedicineSwitch,
                                        "post_image": receivedImageURL,
                                        "post_hospital": receivedHospitalSwitch] as [String : Any]

                            postDetailRef.setValue(post)
                            return
                        }
                    }
                    let post = ["post_content": contentToDB, // 글 내용 저장
                                "post_updated_date": current_date_string, // 글 업로드 시기 저장
                                "post_date": selectedDate, // 글 자체의 날짜 저장
                                "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                                "post_wash": receivedWashSwitch,
                                "post_medicine": receivedMedicineSwitch,
                                "post_image": receivedImageURL,
                                "post_hospital": receivedHospitalSwitch] as [String : Any]

                    postDetailRef.setValue(post)
                }
            } else {
                let post = ["post_content": contentToDB, // 글 내용 저장
                            "post_updated_date": current_date_string, // 글 업로드 시기 저장
                            "post_date": selectedDate, // 글 자체의 날짜 저장
                            "post_walk": receivedWalkSwitch, // 산책, 목욕, 약, 병원, 스위치 상태 저장
                            "post_wash": receivedWashSwitch,
                            "post_medicine": receivedMedicineSwitch,
                            "post_image": receivedImageURL,
                            "post_hospital": receivedHospitalSwitch] as [String : Any]

                postDetailRef.setValue(post)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    // get content from db
    func showContentFromDB(deviceToken: String, selectedDate: String,
                           completion: @escaping (String) -> Void) {
        let postRef: DatabaseReference! = Database.database().reference().child("Post").child("\(deviceToken)")
        
        postRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                if let value = snapshot.value as? Dictionary<String, Any> {
                    //let dic = values as! [String : [String:Any]]
                    for index in value {
                        if let post = index.value as? Dictionary<String, Any> {
                            if post["post_date"] as? String == selectedDate {
                                completion(post["post_content"] as! String)
                            }
                        }
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func showImageFromDB(deviceToken: String, postUpdatedDate: String,
                         completion: @escaping (UIImage) -> Void) {
        let storage = Storage.storage()
        // Create a reference from a Google Cloud Storage URI
        let gsRef = storage.reference(forURL: "gs://mypetdiary-475e9.appspot.com/2021-01-21 19:40:41E0A70A86-CD62-4D26-A218-4385A77AC8D0.jpeg")
        
        // Create a reference to the file you want to download
        //let islandRef = storageRef.child("\(postUpdatedDate)\(deviceToken).jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        gsRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
          }
        }
    }
}
