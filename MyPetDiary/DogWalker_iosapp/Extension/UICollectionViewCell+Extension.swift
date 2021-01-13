//
//  UICollectionViewCell+Extension.swift
//  DogWalker_iosapp
//
//  Created by 정지연 on 2021/01/13.
//

import UIKit

extension UICollectionViewCell {
    
    // Datacell과 Memocell의 생김새를 config
    func configApperance(at view: UIView) {
        view.layer.cornerRadius = Config.Appearance.cellCornerRadius
        view.layer.borderColor = UIColor.borderColor().cgColor
        view.layer.borderWidth = Config.Appearance.cellBorderWidth
        view.layer.masksToBounds = true
    }
}
