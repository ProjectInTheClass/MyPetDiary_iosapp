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

    @IBOutlet var calendarView: FSCalendar!
    @IBAction func unwindFromVC3(seque: UIStoryboardSegue){
        showTodo()
    }
    
    var ref: DatabaseReference! = Database.database().reference()
    let deviceToken = UserDefaults.standard.string(forKey: "token")!
    
    let petDStorage = PetDFirebaseStorage.shared // firebase storage reference
    let postDataModel = FirebasePostDataModel.shared // post DB reference
    
    @IBOutlet weak var subPostView: UIStackView!
    // subview
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var walkingLabel: UILabel!
    @IBOutlet weak var washLabel: UILabel!
    @IBOutlet weak var medicineLabel: UILabel!
    @IBOutlet weak var hospitalLabel: UILabel!
    
    // tab하면 화면 넘어가기
    @IBAction func showPostTapGesture(_ sender: Any) {
        // 뷰 객체 얻어오기 (storyboard ID로 ViewController구분)
        guard let uvc = storyboard?.instantiateViewController(identifier: "TdMemoViewController") else {
            return
        }
        
        // 화면 전환 애니메이션 설정
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(uvc, animated: true)
    }

    var dates = [Date]()
    let formatter = DateFormatter()
    
    var selectedDateString: String = ""
    var flag: Int = 0
    
    func todayDateFirst() {
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDateString = formatter.string(from: Date())
        print("selected\(selectedDateString)")
    }
    
    func setCalendar(){ // 달력 기본 설정
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
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if dates.contains(date) {
            return 1
        } else {
            return 0
        }
    }
    
    // eventdot 표현 -> 오늘 한 일 표현한걸로 바꾸기
    func getDB() {
        postDataModel.showAllDate(deviceToken: deviceToken, completion: { [self] alldate in
            self.dates = alldate.compactMap { self.formatter.date(from: $0) }
            
            self.calendarView.reloadData()
        })
    }
    
//    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
//
//        let labelMy2 = UILabel(frame: CGRect(x: 10, y: 20, width: cell.bounds.width, height: 30))
//        labelMy2.font = UIFont(name: "Noteworthy", size: 7)
//        labelMy2.layer.cornerRadius = cell.bounds.width/2
//        labelMy2.text = "🌿"
//        labelMy2.text! += "💊🏥🛁"
//
//        cell.addSubview(labelMy2)
//
//    }
//
    // 날짜 선택 시 콜백 메소드
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDateString = formatter.string(from: date)
        print(selectedDateString + " 선택됨")
        
        showTodo()
        showImage()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "ShowSubSegue" {
            
            guard let TodayMemoViewController = segue.destination as? TodayMemoViewController else {return}
            
            TodayMemoViewController.selectedDate = self.selectedDateString
        } else if segue.identifier == "AddPostSegue" {
            
            guard let AddDiaryViewController = segue.destination as? AddDiaryViewController else {return}
            
            AddDiaryViewController.selectedDate = self.selectedDateString
        }
        
    }
    
    // 캘린더에서 해당 날짜 라벨 표시하기
    func showTodo(){
        
        postDataModel
            .showSwitchFromDB(deviceToken: deviceToken, selectedDate: selectedDateString, completion: {
            walkDB, washDB, medicineDB, hospitalDB, nothing in
                print("printlabel")
                if nothing { // DB에 데이터가 있는 경우
                    print("데이터 있음")
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
                }
        })
    }
    
    func showImage() {
        // subImage에 image 불러오기
        postDataModel
            .showUploadTimeFromDB(deviceToken: deviceToken, selectedDate: selectedDateString, completion: {
                uploadTime in
                self.petDStorage.loadMemoImage(post_updated_date: uploadTime, deviceToken: self.deviceToken, completion: {
                    image in
                    self.subImageView.image = image
                })
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
//        // tab하면 모달 띄우기
//        self.subPostView.isUserInteractionEnabled = true
//        self.subPostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPostTapGesture)))
        
        todayDateFirst()
        getDB()
        setCalendar()
        showTodo()
        showImage()
    
        calendarView.delegate = self
        calendarView.dataSource = self
    }
}
