//
//  AddDiaryViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/05.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos

class AddDiaryViewController: UIViewController{
    
    @IBOutlet weak var showDate: UILabel!
    let picker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isWalked: UISwitch! // 산책 스위치
    @IBOutlet weak var walk: UILabel! // 산책 라벨
    @IBOutlet weak var isWashed: UISwitch! // 목욕 스위치
    @IBOutlet weak var wash: UILabel! // 목욕 라벨
    @IBOutlet weak var isMedicine: UISwitch! // 약 스위치
    @IBOutlet weak var medicine: UILabel! // 약 라벨
    @IBOutlet weak var isHospital: UISwitch! // 병원 스위치
    @IBOutlet weak var hospital: UILabel! // 병원 라벨
    
    var fetchResult: PHFetchResult<PHAsset>?
    var canAccessImages: [UIImage] = []
    
    @IBAction func isOnWalk(_ sender: UISwitch) {
        if sender.isOn {
            self.walk.text = "산책완료!😄"
        } else {
            self.walk.text = "산책"
        }
    }
    @IBAction func isOnWash(_ sender: UISwitch) {
        if sender.isOn {
            self.wash.text = "목욕완료!😄"
        } else {
            self.wash.text = "목욕"
        }
    }
    @IBAction func isOnMedicine(_ sender: UISwitch) {
        if sender.isOn {
            self.medicine.text = "약완료!😄"
        } else {
            self.medicine.text = "약"
        }
    }
    @IBAction func isOnHospital(_ sender: UISwitch) {
        if sender.isOn {
            self.hospital.text = "병원완료!😄"
        } else {
            self.hospital.text = "병원"
        }
    }
    
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        showDate.text = "\(str)"   //라벨에 출력
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        getCurrentDateTime()
    }
    
    func settingAlert(){
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{
            let alert = UIAlertController(title: "Alert", message: "\(appName)이(가) 카메라 접근이 허용되지 않았습니다. 설정화면으로 이동하시겠습니까?", preferredStyle:  .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .default){ (action) in
                //
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default){ (action) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            alert.addAction(cancelAction)
            alert.addAction(confirmAction)
            self.present(alert, animated: true, completion: nil)
        }else{
            //
        }
    }


    @IBAction func addImage(_ sender: Any) {
        let alert =  UIAlertController(title: "사진을 등록하세요!", message: " ", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        switch PHPhotoLibrary.authorizationStatus(){
        case .denied:
            settingAlert()
        case .restricted:
            break
//        case .limited:
            
        case .authorized:
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized{
                    DispatchQueue.main.async{
                        alert.addAction(library)
                        alert.addAction(camera)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
        }

//        alert.addAction(library)
//        alert.addAction(camera)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)

    }
    
    // picker = UIImagePickerController
    // 사진앨범을 누르면 picker의 소스타입을 사진 라이브러리로
    // 카메라를 누르면 소스타입을 카메라로 지정
    func openLibrary(){
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }else{
            print("Camera not available")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // destView : UIViewController
        let destView = segue.destination
        
        // AddPostViewController로 타입캐스팅
        
    }
    
}

extension AddDiaryViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
//            print(info)
            
        }
        dismiss(animated: true, completion: nil)
      
    }
}
