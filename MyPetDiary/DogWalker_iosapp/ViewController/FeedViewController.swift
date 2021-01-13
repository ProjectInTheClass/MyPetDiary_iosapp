//
//  FeedViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/04.
//

import Foundation
import FSCalendar
import RealmSwift

class FeedViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet var calendarView: FSCalendar!
    @IBAction func unwindFromVC3(seque: UIStoryboardSegue){ }
    @IBOutlet weak var subView: UICollectionView!
    
    
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
        // 캘린더에 이번달 날짜만 표시하기 위함
        calendarView.placeholderType = .none
        // Month 폰트 설정
        calendarView.appearance.headerTitleFont = UIFont(name: Config.Font.normal, size: Config.FontSize.month)
        // day 폰트 설정
        calendarView.appearance.titleFont = UIFont(name: Config.Font.bold, size: Config.FontSize.day)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        setCalendar()
        
    }

}



