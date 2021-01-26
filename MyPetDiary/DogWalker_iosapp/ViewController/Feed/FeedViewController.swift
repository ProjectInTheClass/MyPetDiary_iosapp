//
//  FeedViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/04.
//

import Foundation
import FSCalendar
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseStorage

class FeedViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var ref: DatabaseReference! = Database.database().reference()
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    var dates = [Date]()
    let formatter = DateFormatter()
    var selectedDateString: String = ""
    var flag: Int = 0

    @IBOutlet var calendarView: FSCalendar!
    @IBAction func unwindFromVC3(seque: UIStoryboardSegue){}
    
    @IBOutlet weak var subPostView: UIStackView!
    // subview
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var washLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    

    @IBOutlet weak var DeletePostBtn: UIButton!
    
    // tab하면 화면 넘어가기
    @IBAction func showPostTapGesture(_ sender: Any) {
    }
    
    @objc func goPage(sender:UIGestureRecognizer) {
        postDataModel
            .showSwitchFromDB(deviceToken: deviceToken, selectedDate: selectedDateString, completion: {
            walkDB, washDB, medicineDB, hospitalDB, nothing in
                _  = UIStoryboard(name: "Feed", bundle: nil)
                if nothing{
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TdMemoViewController") as? TodayMemoViewController else { return }
                    vc.selectedDate = self.selectedDateString
                    self.present(vc, animated: true, completion: nil)
//                    self.navigationController!.pushViewController(vc, animated: true)
                }else{
                    guard let tvc = self.storyboard?.instantiateViewController(withIdentifier: "FirstAddViewController") as? AddDiaryViewController else { return }
                    tvc.selectedDate = self.selectedDateString
                    self.navigationController!.pushViewController(tvc, animated: true)
                }
            })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
//        if segue.identifier == "ShowSubSegue" {
//            guard let TodayMemoViewController = segue.destination as? TodayMemoViewController else {return}
////            TodayMemoViewController.selectedDate = self.selectedDateString
//        } else if segue.identifier == "AddPostSegue" {
        guard let AddDiaryViewController = segue.destination as? AddDiaryViewController else {return}
        AddDiaryViewController.selectedDate = self.selectedDateString
//        }
    }
 
    // 오늘날짜!
    func todayDateFirst() {
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDateString = formatter.string(from: Date())
        print("selected\(selectedDateString)")
    }
    
    func setCalendar(){ // 달력 기본 설정
        // 달력의 년월 글자 바꾸기
        calendarView.appearance.headerDateFormat = "YYYY년 M월"
        // 달력의 요일 글자 바꾸는 방법 1
        calendarView.locale = Locale(identifier: "ko_KR")
        calendarView.appearance.titleFont = UIFont(name: "Cafe24Oneprettynight", size: 14)
        calendarView.appearance.weekdayFont = UIFont(name: "Cafe24Oneprettynight", size: 14)
        calendarView.appearance.headerTitleFont = UIFont(name: "Cafe24Oneprettynight", size: 17)
        // 달력의 평일 날짜 색
        calendarView.appearance.titleDefaultColor = .black
        // 달력의 토,일 날짜 색
        calendarView.appearance.titleWeekendColor = .red
        // 달력의 년도, 월 색
        calendarView.appearance.headerTitleColor = .systemPink
        // 달력의 요일 글짜 색
        calendarView.appearance.weekdayTextColor = .orange
        // 년월 흐릿하게 보이는거 삭제
        calendarView.appearance.headerMinimumDissolvedAlpha = 0
        // 오늘 날짜 색
        calendarView.appearance.todayColor = .systemPink
        // 선택한 날짜 색
        calendarView.appearance.selectionColor = .lightGray
        // 선택한 날짜 모서리 (0 = 사각형)
        calendarView.appearance.borderRadius = 1
        // weekday name 변경
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesSingleUpperCase
        // 달이 보이게
        calendarView.scope = .month
        // event 색
        calendarView.appearance.eventDefaultColor = .red
        calendarView.appearance.eventSelectionColor = .red
        // 캘린더에 이번달 날짜만 표시하기 위함
        calendarView.placeholderType = .none
    }
    
    // event dot
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if dates.contains(date) {
//            switch flag{
//            case 1:
//                print("event1")
//                return 1
//            case 2:
//                print("event2")
//                return 2
//            case 3:
//                print("event3")
//                return 3
//            case 4:
//                print("event4")
//                return 4
//            default:
//                print("event0")
//                return 1
//            }
            return 1
        } else {
            return 0
        }
    }
    
    // 게시글 삭제 버튼
    @IBAction func deletePostBtn(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "일기를 삭제하시겠습니까?", message: "한번 삭제된 일기는 되돌릴 수 없습니다", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        
        let cancel = UIAlertAction(title: "아니오", style: .cancel, handler : nil)
        let ok = UIAlertAction(title: "예", style: .default, handler : { [self]_ in
            postDataModel.deletePost(deviceToken: self.deviceToken, selectedDate: selectedDateString)
            getDB()
            showTodo()
            showImage()
            self.calendarView.reloadData()
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // eventdot 표현 -> 오늘 한 일 표현한걸로 바꾸기
    func getDB() {
        postDataModel.showAllDate(deviceToken: deviceToken, completion: { [self] alldate in
            self.dates = alldate.compactMap { self.formatter.date(from: $0) }
            self.calendarView.reloadData()
        })
    }

    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateString = formatter.string(from: date)
        print(selectedDateString + " 선택됨")
        getDB()
        showTodo()
        showImage()
    }
    
    // 캘린더에서 해당 날짜 라벨 표시하기
    func showTodo(){
        postDataModel
            .showSwitchFromDB(deviceToken: deviceToken, selectedDate: selectedDateString, completion: {
            walkDB, washDB, medicineDB, hospitalDB, nothing in
                print("printlabel")
                if nothing { // DB에 데이터가 있는 경우
                    print("데이터 있음")
                    self.DeletePostBtn.isHidden = false
                    
                    if walkDB {
                        self.walkingLabel.isHidden = false
                        self.walkingLabel.text = "🌿산책"
                    } else { self.walkingLabel.isHidden = true }
                    
                    if washDB {
                        self.washLabel.isHidden = false
                        self.washLabel.text = "🛁목욕"
                    } else { self.washLabel.isHidden = true }
                    
                    if medicineDB {
                        self.medicineLabel.isHidden = false
                        self.medicineLabel.text = "💊약"
                    } else { self.medicineLabel.isHidden = true }
                    
                    if hospitalDB {
                        self.hospitalLabel.isHidden = false
                        self.hospitalLabel.text = "🏥병원"
                    } else { self.hospitalLabel.isHidden = true }
                    
                } else { // DB에 데이터가 없는 경우
                    print("데이터 없음")
                    self.walkingLabel.isHidden = true
                    self.washLabel.isHidden = true
                    self.medicineLabel.isHidden = true
                    self.hospitalLabel.isHidden = true
                    self.DeletePostBtn.isHidden = true
                }
        })
    }
    
    func showImage() {
        // subImage에 image 불러오기
        postDataModel
            .showUploadTimeFromDB(deviceToken: deviceToken, selectedDate: selectedDateString, completion: {
                (uploadTime, isSomething) in
                if isSomething { // 저장된 사진이 있으면
                    self.petDStorage.loadMemoImage(post_updated_date: uploadTime, deviceToken: self.deviceToken, selectedDate: self.selectedDateString, completion: {
                        image in
                        self.subImageView.image = image
                    })
                }
                else { // 사진이 없을 경우
                    self.subImageView.image = nil
                }
            })
    }
    
    func showEventDate() {
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
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        self.dates = strArr.compactMap { self.formatter.date(from: $0) }
        print("alldate:\(self.dates)")
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Touch Event 등록 후 함수를 연동한다. (goPage)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(FeedViewController.goPage(sender:)))
        self.subPostView.addGestureRecognizer(gesture)

        todayDateFirst()
        getDB()
        setCalendar()
        showTodo()
        showImage()
    
        calendarView.delegate = self
        calendarView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidappear")
        getDB()
        showTodo()
        showImage()
        self.calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewwillappear")
        getDB()
        showTodo()
        showImage()
        self.calendarView.reloadData()
    }
    
}
