//
//  PetDiFirebaseManager.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/14.
//

import Foundation
import Firebase
import FirebaseDatabase
import RxSwift

struct User: Codable {
    //var user_token: String
    var user_nickName: String
}

extension User {
    func toDictionary() -> [String: Any] {
        return ["user_nickName": user_nickName]
    }
}

class PetDiFirebaseManager {
    class func add(user: User) {
        let rootRef = Database.database().reference()
        let usersRef = rootRef.child("users")
        
        let userRef = usersRef.childByAutoId()
        userRef.setValue(user.toDictionary())
    }
}

struct AddUserViewModel {
    
    struct State {
        
    }
    
    struct Action {
        let saveUser = PublishSubject<User>()
    }
    
    let state = State()
    let action = Action()
    private let bag = DisposeBag()
    
    init() {
        action.saveUser.subscribe(onNext: {user in
            PetDiFirebaseManager.add(user: user)
        }).disposed(by: bag)
    }
}
