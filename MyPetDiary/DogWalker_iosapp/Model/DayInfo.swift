//
//  DayInfo.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/13.
//

import Foundation
import RealmSwift

// Realm에 들어갈 데이터 모델링.
class DayInfo: Object {
    @objc dynamic var year = 0
    @objc dynamic var month = 0
    @objc dynamic var day = 0
    @objc dynamic var achievement = ""
    @objc dynamic var memo = ""
}
