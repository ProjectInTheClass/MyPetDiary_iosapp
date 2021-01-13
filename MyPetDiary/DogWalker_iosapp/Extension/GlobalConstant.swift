//
//  GlobalConstant.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/13.
//

import Foundation
import UIKit

/// 쓰이는 폰트 종류
enum FontType {
    case weekday
    case memo
    case today
}

/// Background 타입 종류
enum BackGroundType {
    case mainView, inputView, subView
}

struct Config {
    struct Appearance {
        static let dayBorderRadius: CGFloat = 0
        static let headerAlpha: CGFloat = 0.1
        static let achievementRadius: CGFloat = 20.0
        static let cellCornerRadius: CGFloat = 15
        static let cellBorderWidth: CGFloat = 2
        static let maximumLength: Int = 250
        static let graphLabelHeight: CGFloat = 20.0
    }
    struct AspectRatio {
        static let cellAspectRatio: CGFloat = 1.1
        static let calendarHeightRatio: CGFloat = 1.8
        static let pickerViewHeight: CGFloat = 150
        static let pickerRowHeight: CGFloat = 40
        static let sectionLine: CGFloat = 1.5
    }
}

// MemoCell에서 MainVC로 성취도 입력 화면 모달을 열어달라고 요청하기 위해 추가한 프로토콜
protocol UserAddNewAchievementDelegate {
    func showInputModal(from date: Date)
}

// 어떤 날짜를 선택하면, memocell로 notification 보내기 위해 추가
let UserClickSomeDayNotification = Notification.Name("UserClickSomeDay")
