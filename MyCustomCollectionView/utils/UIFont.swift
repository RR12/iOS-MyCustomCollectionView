//
//  UIFont.swift
//  MyCustomCollectionView
//
//  Created by Ivan Kristianto on 10/21/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

extension UIFont {
    static var row: UIFont {
        return systemFont(ofSize: 11)
    }
    
    static var screen: UIFont {
        return systemFont(ofSize: 12)
    }
    
    static var seat: UIFont {
        return systemFont(ofSize: 7)
    }
    
    static var titleSeat: UIFont {
        return systemFont(ofSize: 10, weight: UIFontWeightHeavy)
    }
}
