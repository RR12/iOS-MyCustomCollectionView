//
//  CinemaSeatView.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/18/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit
import QuartzCore

protocol CinemaSeatViewDelegate: class {
    
    func onSeatSizeChanged(_ size: CGSize)
    
    func didSelectSeat(row: Int, column: Int)
    
    func didUnselectSeat(row: Int, column: Int)
    
    func onSeatScrolled(x: CGFloat, y: CGFloat)
    
}

extension CinemaSeatViewDelegate {
    
    func onSeatScrolled(x: CGFloat, y: CGFloat) {}
    
}

class CinemaSeatView: UIView {
    
    private var seatWidth: CGFloat = 0 {
        didSet {
            let w = (seatWidth * currentScale) + (seatSpacing * currentScale)
            delegate?.onSeatSizeChanged(CGSize(width: w, height: w))
        }
    }
    private var seatSpacing: CGFloat = 4
    private var originalRect: CGRect = .zero
    private var currectRect: CGRect = .zero
    private var rowCount = 0
    private var columnCount = 0
    
    private let seatRadii = CGSize(width: 3.0, height: 3.0)
    
    private lazy var seatLabelAttributes: [NSAttributedStringKey: Any] = {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 7),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: style
        ]
    }()
    
    weak var delegate: CinemaSeatViewDelegate?
    
    var seats = [Seat]() {
        didSet {
            calculateRowColumn()
            setNeedsDisplay()
        }
    }
    
    var currentScale: CGFloat = 0 {
        didSet {
            let scaledSeatWidth = (seatWidth * currentScale) + (seatSpacing * currentScale)
            let seatSize = CGSize(width: scaledSeatWidth, height: scaledSeatWidth)
            delegate?.onSeatSizeChanged(seatSize)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        print(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        calculateSeatWidth(rect: rect)
        drawSeat(context: context)
    }
    
    private func initialize() {
        backgroundColor = UIColor.white
    }
    
    private func calculateSeatWidth(rect: CGRect) {
        let totalSpacing = seatSpacing * CGFloat(columnCount + 1)
        seatWidth = (rect.width - totalSpacing) / CGFloat(columnCount)
    }
    
    private func calculateRowColumn() {
        var maxRowCount = 0
        var maxColumnCount = 0
        var currentRowColumnCount = 0
        var currentRow = 0
        var currentColumn = 0
        
        seats.forEach { seat in
            if currentRow != seat.row {
                currentRow = seat.row
                maxRowCount += 1
                currentRowColumnCount = 0
            }
            if currentColumn != seat.column {
                currentColumn = seat.column
                currentRowColumnCount += 1
            }
            if currentRowColumnCount > maxColumnCount {
                maxColumnCount = currentRowColumnCount
            }
        }
        rowCount = maxRowCount
        columnCount = maxColumnCount
    }
    
    private func drawSeat(context: CGContext) {
        var top: CGFloat = 1.0
        var currentRow = 0
        var leading: CGFloat = 0
        
        seats.forEach { seat in
            if seat.row != currentRow {
                currentRow = seat.row
                leading = 0
                top += (seatWidth + seatSpacing)
            }
            if seat.column == 0 {
                leading = seatSpacing
            } else {
                leading += (seatWidth + seatSpacing)
            }
            
            let rect = CGRect(x: leading, y: top, width: seatWidth, height: seatWidth)
            
            switch (seat.state) {
            case .available:
                drawAvailableSeat(context: context, rect: rect, seatLabel: String(seat.column))
            case .unavailable:
                drawUnavailableSeat(context: context, rect: rect)
            case .selected:
                drawSelectedSeat(context: context, rect: rect)
            }
        }
    }
    
    private func drawAvailableSeat(context: CGContext, rect: CGRect, seatLabel: String) {
        UIColor.gray.set()
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: seatRadii)
        context.addPath(path.cgPath)
        context.strokePath()
    
        (seatLabel as NSString).draw(in: rect,withAttributes: seatLabelAttributes)
    }
    
    private func drawUnavailableSeat(context: CGContext, rect: CGRect) {
        UIColor.darkGrey.set()
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: seatRadii)
        context.addPath(path.cgPath)
        context.fillPath()
    }
    
    private func drawSelectedSeat(context: CGContext, rect: CGRect) {
        UIColor.orange.set()
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: seatRadii)
        context.addPath(path.cgPath)
        context.fillPath()
    }
    
    func onSeatAreaTapped(on point: CGPoint) {
        let column = Int(floor(point.x / (seatWidth + seatSpacing)))
        let row = Int(floor(point.y / (seatWidth + seatSpacing)))
        print("Row = \(row) - Column = \(column)")
        
        seats = seats.map { seat -> Seat in
            if seat.row == row && seat.column == column {
                var newSeat = seat
                switch (seat.state) {
                case .available:
                    newSeat.state = .selected
                    delegate?.didSelectSeat(row: row, column: column)
                case .selected:
                    newSeat.state = .available
                    delegate?.didUnselectSeat(row: row, column: column)
                default: newSeat.state = .unavailable
                }
                return newSeat
            }
            return seat
        }
    }
    
}

struct Seat {
    
    enum State {
        case available
        case unavailable
        case selected
    }
    
    var row: Int
    var column: Int
    var state: State
    
}
