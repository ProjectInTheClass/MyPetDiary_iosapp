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
    
    var dates = [Date]()

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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            guard let modalPresentView = self.storyboard?.instantiateViewController(identifier: "TdMemoViewController") as? TdMemoViewController else { return }
            
            // 날짜를 원하는 형식으로 저장하기 위한 방법입니다.
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            modalPresentView.date = dateFormatter.string(from: date)

            self.present(modalPresentView, animated: true, completion: nil)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        setCalendar()
        
    }

}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // dataCell과 memoCell의 사이즈를 결정하는 메소드
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellHeight = subView.frame.height / Config.AspectRatio.cellAspectRatio
        let cellWidth = subView.frame.width / Config.AspectRatio.cellAspectRatio
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}
