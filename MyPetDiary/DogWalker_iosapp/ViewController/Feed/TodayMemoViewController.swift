//
//  TodayMemoViewController.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/18.
//

import UIKit

class TodayMemoViewController: UIViewController {

    @IBOutlet weak var showDate2: UILabel!
    
    
    
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        showDate2.text = "\(str)"   //라벨에 출력
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getCurrentDateTime()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


