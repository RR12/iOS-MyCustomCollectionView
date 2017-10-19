//
//  CinemaScreenView.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/19/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

class CinemaScreenView: UIView {
    
    private lazy var screenLabelAttributes: [NSAttributedStringKey: Any] = {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: style
        ]
    }()
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        let qurvedX = (rect.width * 0.5)
        let qurvedY = (rect.height * 0.5) - (rect.height * 0.3)
        let startX = qurvedX - ((rect.width * 0.8) * 0.5)
        let startY = (rect.height * 0.5) + (rect.height * 0.3)
        let endX = qurvedX + ((rect.width * 0.8) * 0.5)
        
        UIColor.darkGrey.set()
        context.setLineWidth(2.0)
        context.move(to: CGPoint(x: startX, y: startY))
        context.addQuadCurve(
            to: CGPoint(x: endX, y: startY),
            control: CGPoint(x: qurvedX, y: qurvedY)
        )
        context.strokePath()
        
        let labelRect = CGRect(x: 0, y: rect.height * 0.6, width: rect.width, height: rect.height)
        ("SCREEN" as NSString).draw(in: labelRect, withAttributes: screenLabelAttributes)
    }
    
}
