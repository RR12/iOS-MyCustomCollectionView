//
//  UIView+Nib.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/19/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

extension UIView {
    
    func loadNib() {
        if let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
}
