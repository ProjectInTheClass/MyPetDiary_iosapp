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
    
    // eventdot 표현 -> 오늘 한 일 표현한걸로 바꾸기
    func presentEventDot(){
        let xmas = formatter.date(from: "2021-01-09")
        let sampledate = formatter.date(from: "2021-01-17")
        dates = [xmas!, sampledate!]
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if dates.contains(date){
            return 1
        }
        return 0
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
        viewWillAppear(true)
//        viewDidLoad()
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
    
    func showTodo(){
        // 기기 토큰 확인하기
        
        print("글 쓰기 기기 토큰 확인:"+deviceToken)
        showEventLabel(deviceToken: deviceToken)
//        viewDidLoad()
    }
    
//    func initLabel() {
//        self.walkingLabel.isHidden = true // hide
//        self.washLabel.isHidden = true
//        self.medicineLabel.isHidden = true
//        self.hospitalLabel.isHidden = true
//    }
    
    // 해당 날짜 라벨 보여주기
    func showEventLabel(deviceToken: String) {
        ref.child("Post").child("\(deviceToken)").observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                let values = snapshot.value
                let dic = values as! [String : [String:Any]]
                
                if self.selectedDateString == "" {
//                    let formatter = DateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd"
                    self.selectedDateString = self.formatter.string(from: Date())
                }
//                initLabel()
                self.walkingLabel.isHidden = true // hide
                self.washLabel.isHidden = true
                self.medicineLabel.isHidden = true
                self.hospitalLabel.isHidden = true

                print("오늘날짜:\(self.selectedDateString)")
                for index in dic {
                    if (index.value["post_date"] as? String == self.selectedDateString) {
                        print(index.key)
                        print(index.value["post_walk"] ?? false)
                        print(index.value["post_wash"] ?? false)
                        print(index.value["post_medicine"] ?? false)
                        print(index.value["post_hospital"] ?? false)
                        
                        if index.value["post_walk"] as! Bool {
                            self.walkingLabel.isHidden = false
                            self.walkingLabel.text = "🌿산책"
                        } else {
                            self.walkingLabel.isHidden = true
                        }
                        if index.value["post_wash"] as! Bool {
                            self.washLabel.isHidden = false
                            self.washLabel.text = "🛁목욕"
                        } else {
                            self.washLabel.isHidden = true
                        }
                        if index.value["post_medicine"] as! Bool {
                            self.medicineLabel.isHidden = false
                            self.medicineLabel.text = "💊약"
                        } else {
                            self.medicineLabel.isHidden = true
                        }
                        if index.value["post_hospital"] as! Bool {
                            self.hospitalLabel.isHidden = false
                            self.hospitalLabel.text = "🏥병원"
                        } else {
                            self.hospitalLabel.isHidden = true
                        }
                        
                    }
                }
            } else {
                self.walkingLabel.isHidden = true // hide
                self.washLabel.isHidden = true
                self.medicineLabel.isHidden = true
                self.hospitalLabel.isHidden = true
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadMemoImage() {
        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: "postImage/MyPetDiary.jpg")
        
        // Create a reference to the file you want to download
        //let islandRef = storageRef.child("images/island.jpg")

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error.localizedDescription)
          } else {
            // Data for "images/island.jpg" is returned
            let downloadImage = UIImage(data: data!)
            self.subImageView.image = downloadImage
          }
        }
    }
    
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd"
        
        // Do any additional setup after loading the view.
//        // tab하면 모달 띄우기
//        self.subPostView.isUserInteractionEnabled = true
//        self.subPostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.showPostTapGesture)))
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        presentEventDot()
        setCalendar()
//        initLabel()
//        showTodo()
        
        loadMemoImage()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        showTodo()
    }
}
