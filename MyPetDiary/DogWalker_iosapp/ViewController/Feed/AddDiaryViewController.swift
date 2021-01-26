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
import Firebase
import FirebaseDatabase

class AddDiaryViewController: UIViewController{
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var showDate: UILabel!
    let picker = UIImagePickerController()
    
    @IBOutlet weak var RecordWhatHappen: UILabel!
    @IBOutlet weak var selectImgBtn: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var isWalked: UISwitch! // 산책 스위치
    @IBOutlet weak var walk: UILabel! // 산책 라벨
    @IBOutlet weak var isWashed: UISwitch! // 목욕 스위치
    @IBOutlet weak var wash: UILabel! // 목욕 라벨
    @IBOutlet weak var isMedicine: UISwitch! // 약 스위치
    @IBOutlet weak var medicine: UILabel! // 약 라벨
    @IBOutlet weak var isHospital: UISwitch! // 병원 스위치
    @IBOutlet weak var hospital: UILabel! // 병원 라벨
    var showDateData = "" // 넘겨줄 날짜 데이터
    var localFile = "" // 넘겨줄 사진 파일 url
    var filePath = "" // 넘겨줄 사진 path
    var photoData: NSData? = nil // 넘겨줄 사진 data
    
    var fetchResult: PHFetchResult<PHAsset>?
    var canAccessImages: [UIImage] = []
    var selectedDate: String = ""
    
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    
    // 기기 토큰 확인하기
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    
    @IBAction func goNextPage(_ sender: UIButton) {
        
        
        // 처음 게시글을 작성할 경우 입력한 사진이 없을 경우
        if imageView.image == nil {
            // create the alert
            let alert = UIAlertController(title: "사진이 비어있음", message: "입력할 사진을 넣어주세요", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler:nil
            ))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Feed", bundle: nil)
            let vc = storyBoard.instantiateViewController(identifier:"SecondAddViewController") as! AddPostViewController
            
            // 타입 캐스팅후 값 할당
            vc.receivedImage = self.imageView
            vc.receivedWalkSwitch = self.isWalked.isOn
            vc.receivedWashSwitch = self.isWashed.isOn
            vc.receivedMedicineSwitch = self.isMedicine.isOn
            vc.receivedHospitalSwitch = self.isHospital.isOn
            vc.receivedPostDate = self.showDateData
            vc.receivedImageURL = self.localFile
            vc.receivedFilePath = self.filePath
            vc.receivedPhotoData = self.photoData
            if photoData == nil {
                photoData = imageView.image!.jpegData(compressionQuality: 0.7) as NSData?;
            }
//            self.present(vc, animated: true, completion: nil)
            self.show(vc, sender: self)
        }
    }
    @IBAction func isOnWalk(_ sender: UISwitch) {
        if sender.isOn {
            self.walk.text = "산책🙆🏻‍♀️"
        } else {
            self.walk.text = "산책"
        }
    }
    @IBAction func isOnWash(_ sender: UISwitch) {
        if sender.isOn {
            self.wash.text = "목욕🙆🏻‍♀️"
        } else {
            self.wash.text = "목욕"
        }
    }
    @IBAction func isOnMedicine(_ sender: UISwitch) {
        if sender.isOn {
            self.medicine.text = "약🙆🏻‍♀️"
        } else {
            self.medicine.text = "약"
        }
    }
    @IBAction func isOnHospital(_ sender: UISwitch) {
        if sender.isOn {
            self.hospital.text = "병원🙆🏻‍♀️"
        } else {
            self.hospital.text = "병원"
        }
    }
    
    // 선택된 날짜
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        if selectedDate == "" {
            showDate.text = "\(str)"   //라벨에 출력
            formatter.dateFormat = "yyyy-MM-dd"
            let dateData = formatter.string(from: Date()) //문자열로 바꾸기
            showDateData = dateData
        }else{
            showDate.text = selectedDate
            showDateData = selectedDate
        }
    }
    
    
    
   
    
    func fontChange() {
        showDate.font = UIFont(name: "SDSamliphopangcheBasic", size: 20)
        RecordWhatHappen.font = UIFont(name: "SDSamliphopangcheBasic", size: 15)
        selectImgBtn.titleLabel?.font = UIFont(name: "SDSamliphopangcheBasic", size: 15)
        nextBtn.titleLabel?.font = UIFont(name: "SDSamliphopangcheBasic", size: 20)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        getCurrentDateTime()
        
        fontChange()
        
        // 기존 데이터 있을 경우 image 불러오기
        postDataModel
            .showUploadTimeFromDB(deviceToken: deviceToken, selectedDate: showDateData, completion: {
                uploadTime, isSomething in
                if isSomething {
                    self.petDStorage.loadMemoImage(post_updated_date: uploadTime,
                                                   deviceToken: self.deviceToken,
                                                   selectedDate: self.selectedDate,
                                                   completion: {
                        image in
                        self.imageView.image = image
                        self.photoData = image.jpegData(compressionQuality: 0.7) as NSData?
                    })
                } else {
                    self.imageView.image = nil
                }
            })
        
        // 기존 데이터 있을 경우 switch 정보 가져오기
        postDataModel.showSwitchFromDB(deviceToken: "\(deviceToken)", selectedDate: showDateData, completion: {
            walkDB, washDB, medicineDB, hospitalDB, something in
            if something {
                self.isWalked.isOn = walkDB
                self.isWashed.isOn = washDB
                self.isMedicine.isOn = medicineDB
                self.isHospital.isOn = hospitalDB
                if walkDB == true{
                    self.walk.text = "산책🙆🏻‍♀️"
                }
                if washDB == true{
                    self.wash.text = "목욕🙆🏻‍♀️"
                }
                if medicineDB == true{
                    self.medicine.text = "약🙆🏻‍♀️"
                }
                if hospitalDB == true{
                    self.hospital.text = "병원🙆🏻‍♀️"
                }
            }
        })
        
    }
    
    func settingAlert(){
        if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String{
            let alert = UIAlertController(title: "Alert", message: "\(appName)이(가) 카메라 접근이 허용되지 않았습니다. 설정으로 이동하시겠습니까?", preferredStyle:  .alert)
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
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "앨범에서 선택", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라 촬영", style: .default) { (action) in
            self.openCamera()
        }
        let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        
        switch PHPhotoLibrary.authorizationStatus(){
        case .denied:
            settingAlert()
        case .restricted:
            break
        case .authorized:
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = sender as? UIView
                popoverController.sourceRect = (sender as AnyObject).bounds
            }
            present(alert, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ state in
                if state == .authorized{
                    DispatchQueue.main.async{
                        alert.addAction(library)
                        alert.addAction(camera)
                        alert.addAction(cancel)
                        if let popoverController = alert.popoverPresentationController {
                            popoverController.sourceView = sender as? UIView
                            popoverController.sourceRect = (sender as AnyObject).bounds
                        }
                        self.present(alert, animated: true, completion: nil)
                    }
                }else{
                    if let popoverController = alert.popoverPresentationController {
                        popoverController.sourceView = sender as? UIView
                        popoverController.sourceRect = (sender as AnyObject).bounds
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            })
        default:
            break
        }
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
        // 캐스팅시에는 항상 실패할 상황을 염두하여 옵셔널 바인딩을 해준다.
        guard destView is AddPostViewController else {
            return
        }
        
    }
    
}

extension AddDiaryViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            imageView.image = image
            let size = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
            let resizedImage = image.resizeImage(targetSize: size)
            photoData = resizedImage!.pngData() as NSData?
        }
        
//        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
//        let imageName=imageUrl?.lastPathComponent//파일이름
//        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//
//        let photoURL = NSURL(fileURLWithPath: documentDirectory)
//        print("photoURL\(photoURL)")
//        let localPath = photoURL.appendingPathComponent(imageName!)//파일경로
//        photoData = NSData(contentsOf: imageUrl as! URL)!
//        print("lastURL:\(localPath!.path)")
//        filePath = localPath!.path
//        //localFile = String(describing: localPath)
//        var str = "file://"
//        let fileURL = "\(localPath!.path)"
//        str.append(fileURL)
//        localFile = str
//        //localFile = String(decoding: localPath!, as: UTF8.self)
//        print("localFile:"+localFile)
        dismiss(animated: true, completion: nil)
      
    }
}
