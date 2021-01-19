//
//  SubMemoCollectionViewCell.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/13.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseDatabase

class SubMemoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MemoCollectionViewCell"
    
    var ref: DatabaseReference! = Database.database().reference()

    @IBOutlet weak var memoView: UIView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var memoContent: UITextView!
    @IBOutlet weak var sectionLine: UIView!
    @IBOutlet weak var sectionLineWidth: NSLayoutConstraint!
    
    var userClickDate: Date?
    var addNewAchievementDelegate: UserAddNewAchievementDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configApperance(at: memoView)
        
        // cell의 title 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: TodayDateCenter.shared.today)
        cellTitle.text = dateString + " " + "cellTitle".localizedLowercase
//        cellTitle.text = TodayDateCenter.shared.year.description + "." + TodayDateCenter.shared.month.description + "." + TodayDateCenter.shared.day.description + " " + "cellTitle".localized
        
        // 메모 내용을 보여주는 textview 설정
        memoContent.textColor = UIColor.lightGray
        memoContent.backgroundColor = .clear
        
        // 초기 로드 시, 오늘 날짜의 메모를 보여주기.
        configMemoView(Date())
        
        // 사용자가 캘린더에서 어떤 날짜를 선택하는 것을 추적할 옵저버 등록
        NotificationCenter.default.addObserver(self, selector: #selector(configMemoView(_:)), name: UserClickSomeDayNotification, object: nil)
        
        // section line 설정
        sectionLineWidth.constant = memoContent.bounds.width / Config.AspectRatio.sectionLine
        
        // 메모 불러오기 전 기기 토큰 확인하기
        let deviceToken = UserDefaults.standard.string(forKey: "token")!
        print("메모 불러오기 전 저장된 기기토큰 확인:"+deviceToken)
        
//        ref.child("Post").child("\(deviceToken)").observeSingleEvent(of: .value, with: { (snapshot) in
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                if dictionary["post_updated_date"] as! String == dateString
//            }
//
//        }) { (error) in
//            print(error.localizedDescription)
//        }
    }
    
    /// 사용자가 캘린더에서 어떤 날짜를 선택하면 memoview의 title 설정을 해주는 메소드
    @objc func configMemoView(_ sender: Any) {
        
        var clickDate = Date()
        
        if let noti = sender as? Notification { // 특정 날짜를 클릭하여, 노티피케이션 옵저버의 호출로 실행되었을 경우.
            guard let receivedDate = noti.object as? Date else { return }
            clickDate = receivedDate
        } else if let today = sender as? Date {  // 초기 로드 시, viewDidLoad()에서 호출되었을 경우.
            clickDate = today
        }
        
        // 현재 보여지는 캘린더의 year, month, day를 db에서 검색해서, 해당 날짜의 데이터가 있는지 없는지 찾아냄.
//        let clickDayComponent = Calendar.current.dateComponents([.year, .month, .day], from: clickDate)
//        guard let year = clickDayComponent.year else { return }
//        guard let month = clickDayComponent.month else { return }
//        guard let day = clickDayComponent.day else { return }
        
        // 메모 cell의 title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale.current
        let dateString = dateFormatter.string(from: clickDate)
        cellTitle.text = dateString + " " + "cellTitle".localizedLowercase
//        cellTitle.text = "\(year).\(month).\(day)" + " " + "cellTitle".localized
        
        
        
//        // db에서 해당 날짜의 메모를 찾아서 memocontent textview에 보여주기
//        if clickDay.count != 0 {    // clickDay는 초기 실행 시는 today이고, 특정 날짜 선택 시 호출될 때는 특정 날짜 date임.
//            guard let clickDayInfo = clickDay.first else { return }
//            
//            if clickDayInfo.memo.lengthOfBytes(using: .unicode) > 0 {
//                memoContent.text = clickDayInfo.memo
//                
//            }else if clickDayInfo.memo.lengthOfBytes(using: .unicode) == 0{
//                memoContent.text = "emptyMemo".localizedLowercase
//            }
//    }
//    
    // 오늘이 아닌 날짜의 성취도 정보를 추가하거나 수정할 수 있도록 함.
        func addNewMemo(_ sender: UIButton) {

        guard let clickDateInfo = userClickDate else { return }
        addNewAchievementDelegate?.showInputModal(from: clickDateInfo)
    }
}
}
