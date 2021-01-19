//
//  TodayMemoViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/18.
//

import UIKit

class TodayMemoViewController: UIViewController {

    static let identifier = "TdMemoViewController"
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var subImageView: UIImageView!
    @IBOutlet weak var memoContent: UITextView!
    
    var userClickDate: Date?
    var selectedDate: String = ""
    
    // 선택된 날짜
    func getCurrentDateTime(){
        cellTitle.text = selectedDate
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCurrentDateTime()
    }

}


