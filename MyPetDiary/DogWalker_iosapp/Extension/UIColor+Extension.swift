//
//  UIColor+Extension.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/13.
//

import Foundation
import UIKit

extension UIColor {
    
    /// 각 폰트의 색상을 리턴하는 메소드
    static func fontColor(_ name: FontType) -> UIColor {
        switch name {
        case .weekday:
            return #colorLiteral(red: 0.4810999632, green: 0.7885328531, blue: 0.4410419762, alpha: 1)
        case .memo:
            return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .today:
            return #colorLiteral(red: 0.9579854608, green: 0.781021893, blue: 0, alpha: 1)
        }
    }
    
    /// 각 type에 따라 background 색을 리턴하는 메소드
    static func viewBackgroundColor(_ type: BackGroundType) -> UIColor {
        switch type {
        case .mainView:
            return #colorLiteral(red: 0.158882767, green: 0.1719311476, blue: 0.2238469422, alpha: 1)
        case .inputView:
            return #colorLiteral(red: 0.1235230342, green: 0.1367119849, blue: 0.1842530966, alpha: 1)
        case .subView:
            return #colorLiteral(red: 0.1896958947, green: 0.2074376941, blue: 0.2753842473, alpha: 1)
        }
    }
    
    /// 캘린더의 각 날짜의 border 색을 리턴하는 메소드
    static func borderColor() -> UIColor {
        return #colorLiteral(red: 0.1834537089, green: 0.2006109357, blue: 0.266325891, alpha: 1)
    }
}
