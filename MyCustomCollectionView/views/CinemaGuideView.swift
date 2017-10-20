//
//  CinemaGuideView.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/19/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

class CinemaGuideView: UIScrollView {
    
    var rows = [String]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private var rowHeight: CGFloat = 0
    private var rowSpacing: CGFloat = 4
    
    private lazy var rowLabelAttributes: [NSAttributedStringKey: Any] = {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSAttributedStringKey.font: UIFont.row,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: style
        ]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        isUserInteractionEnabled = false
    }
    
    override func draw(_ rect: CGRect) {
        var y: CGFloat = 0
        
        for (index, row) in rows.enumerated() {
            y = (CGFloat(index) * rowHeight)
            let rect = CGRect(x: 0, y: y + 0.5 * rowHeight - UIFont.row.lineHeight, width: rect.width, height: rowHeight + rowSpacing)
            (row as NSString).draw(in: rect,withAttributes: rowLabelAttributes)
        }
    }
    
    func updateRowHeight(_ height: CGFloat) {
        let scale = height / rowHeight
        if rowHeight != 0 {
            rowSpacing *= scale
        }
        rowHeight = height
        setNeedsDisplay()
    }
    
}
