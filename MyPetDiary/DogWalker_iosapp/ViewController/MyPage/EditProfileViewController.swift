//
//  EditProfileViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/21.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    var window: UIWindow?

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var editIDTextField: UITextField!
    @IBOutlet weak var editIntroTextField: UITextField! // 소개글 부분
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var photoData: NSData? = nil // 프로필 사진 data
    
    var userDataModel = FirebaseUserDataModel.shared // user DB reference
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    
    //글자수제한
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }

    @IBAction func idTextSize(_ sender: Any) {
        checkMaxLength(textField: editIDTextField, maxLength: 10)
    }
    @IBAction func infoTextSize(_ sender: Any) {
        checkMaxLength(textField: editIntroTextField, maxLength: 20)
    }
    // save 버튼 눌렀을 경우 디비저장 > 마이페이지로 넘어가기
    @IBAction func saveButtonAction(_ sender: Any) {}
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
           print("segue")
           return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 소개글 저장하기
        userDataModel.saveIntro(deviceToken: deviceToken, userIntro: editIntroTextField.text!)
        // 닉네임 저장하기
        userDataModel.saveNickname(deviceToken: deviceToken, nickname: editIDTextField.text!)
        // 프로필 사진 저장하기(realtime database)
        userDataModel.saveProfileImage(deviceToken: deviceToken, nickname: editIDTextField.text!)
        if photoData != nil {
            petDStorage.uploadProfileToStorage(deviceToken: deviceToken, receivedPhotoData: photoData!, nickname: editIDTextField.text!)
        }
    }
    
    let picker = UIImagePickerController()
    var localFile = "" // 넘겨줄 사진 파일 url
    
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
        let alert =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "앨범에서 선택", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라 촬영", style: .default) { (action) in
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
    func imageCircle(){
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.layer.borderWidth = 0
        userImage.clipsToBounds = true
        userImage.layer.borderColor = UIColor.clear.cgColor  //원형 이미지의 테두리 제거
    }
    // 화면터치하면 키보드 없어짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.editIDTextField.resignFirstResponder()
        self.editIntroTextField.resignFirstResponder()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.editIDTextField.resignFirstResponder()
        self.editIntroTextField.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
        return true
    }

    // 프로필 사진 보여주기
    func showProfile() {
        userDataModel.showUserNickname(deviceToken: deviceToken, completion: {
            usernickname in
            self.petDStorage.loadProfileImage(deviceToken: self.deviceToken, nickname: usernickname, completion: {
                profileImage in
                self.userImage.image = profileImage
            })
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editIDTextField.delegate = self
        editIntroTextField.delegate = self
        picker.delegate = self
        imageCircle()
        // Do any additional setup after loading the view.

        // 프로필 사진 보여주기
        showProfile()
        
        // 소개글 보여주기
        userDataModel
            .showIntro(deviceToken: deviceToken, completion: {
                intro in
                self.editIntroTextField.text = intro
            })
        
        // 닉네임 보여주기
        userDataModel
            .showUserNickname(deviceToken: deviceToken, completion: {
                nickname in
                self.editIDTextField.text = nickname
            })
        
        
    }
}



extension EditProfileViewController : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            userImage.image = image
            let size = CGSize(width: image.size.width * 0.3, height: image.size.height * 0.3)
            let resizedImage = image.resizeImage(targetSize: size)
            photoData = resizedImage!.pngData() as NSData?
        }
        let imageUrl=info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        _=imageUrl?.lastPathComponent//파일이름
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        let photoURL = NSURL(fileURLWithPath: documentDirectory)
        print("photoURL\(photoURL)")
        
//        let localPath = photoURL.appendingPathComponent(imageName!)//파일경로
//        let data=NSData(contentsOf: imageUrl as! URL)!
//        print("lastURL:\(localPath!.path)")
        //localFile = String(describing: localPath)
//        var str = "file:///"
//        let fileURL = "\(localPath!.path)"
//        str.append(fileURL)
//        localFile = str
        //localFile = String(decoding: localPath!, as: UTF8.self)
//        print("localFile:"+localFile)
        dismiss(animated: true, completion: nil)

    }
}
