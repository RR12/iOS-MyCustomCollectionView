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

    func didSelectSeat(_ seat: Seat)

    func didUnSelectSeat(row: Int, column: Int)

    func onSeatScrolled(row: CGFloat, column: CGFloat)

}

protocol CinemaSeatViewDataSource: class {

    func numberOfRow(in cinemaSeatView: CinemaSeatView) -> Int

    func cinemaSeatView(_ cinemaSeatView: CinemaSeatView, numberOfColumnAt row: Int) -> Int

    func cinemaSeatView(_ cinemaSeatView: CinemaSeatView, componentForColumn column: Int, at row: Int) -> CinemaSeatComponent

}

extension CinemaSeatViewDelegate {

    func didSelectSeat(_ seat: Seat) {}

    func didUnSelectSeat(row: Int, column: Int) {}

    func onSeatScrolled(row: CGFloat, column: CGFloat) {}

}

class CinemaSeatView: UIView {

    private var seatWidth: CGFloat = 0 {
        didSet {
            let w = (seatWidth * currentScale) + (seatSpacing * currentScale)
            delegate?.onSeatSizeChanged(CGSize(width: w, height: w))
        }
    }
    private var seatSpacing: CGFloat { return 4 }
    private var originalRect: CGRect = .zero
    private var currentRect: CGRect = .zero

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
    weak var dataSource: CinemaSeatViewDataSource? {
        didSet {
            setSeats()
        }
    }
    
    private var cinemaComponents = [[CinemaSeatComponent]]() {
        didSet {
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
        drawComponents(context: context)
    }

    private func initialize() {
        backgroundColor = UIColor.white
    }

    private func calculateSeatWidth(rect: CGRect) {
        guard let count = dataSource?.cinemaSeatView(self, numberOfColumnAt: 0) else {
            return
        }
        let totalSpacing = seatSpacing * CGFloat(count + 1)
        seatWidth = (rect.width - totalSpacing) / CGFloat(count)
    }

    private func drawComponents(context: CGContext) {
        var top: CGFloat = 1.0
        var leading: CGFloat = 0
        
        cinemaComponents.enumerated().forEach { (row, arrComponents) in
            loop : for (column, component) in arrComponents.enumerated() {
                if column == 0 {
                    leading = seatSpacing
                    if row > 0 {
                        top += (seatWidth + seatSpacing)
                    }
                } else {
                    leading += (seatWidth + seatSpacing)
                }
                
                switch component {
                case let seat as Seat:
                    let rect = CGRect(x: leading, y: top, width: seatWidth, height: seatWidth)
                    drawSeat(context: context, seat, rect: rect)
                case _ as Space:
                    break
                case let seatText as SeatText:
                    if column == 0 {
                        let newTop = top + 0.5 * seatWidth - 0.5 * UIFont.titleSeat.lineHeight
                        let rect = CGRect(x: leading, y: newTop, width: superview!.frame.width, height: seatWidth)
                        drawSeatText(context: context, rect: rect, seatText: seatText)
                        break loop
                    } else {
                        fatalError("SeatText only could be used in column 0")
                    }
                default: fatalError("func drawSeat in CinemaSeatView; unknown seat component")
                }
            }
        }
    }

    private func drawSeat(context: CGContext, _ seat: Seat, rect: CGRect) {
        switch seat.state {
        case .available:
            drawAvailableSeat(context: context, rect: rect, seatLabel: seat.text)
        case .unavailable:
            drawUnavailableSeat(context: context, rect: rect)
        case .selected:
            drawSelectedSeat(context: context, rect: rect)
        }
    }
    
    private func drawAvailableSeat(context: CGContext, rect: CGRect, seatLabel: String) {
        UIColor.gray.set()
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: seatRadii)
        context.addPath(path.cgPath)
        context.strokePath()

        (seatLabel as NSString).draw(in: rect, withAttributes: seatLabelAttributes)
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
    
    private func drawSeatText(context: CGContext, rect: CGRect, seatText: SeatText) {
        let style: NSMutableParagraphStyle = NSMutableParagraphStyle()
        style.alignment = .center
        return [
            NSAttributedStringKey.font: UIFont.titleSeat,
            NSAttributedStringKey.foregroundColor: UIColor.darkGray,
            NSAttributedStringKey.paragraphStyle: style
        ]
        (seatText.text.uppercased() as NSString).draw(in: rect, withAttributes: attributes)
    }
    
    private func setSeats() {
        var components = [[CinemaSeatComponent]]()
        guard let dataSource = dataSource else {
            return
        }
        for row in 0..<dataSource.numberOfRow(in: self) {
            loop: for column in 0..<dataSource.cinemaSeatView(self, numberOfColumnAt: row) {
                if column == 0 {
                    components.insert([], at: row)
                }
                
                let component = dataSource.cinemaSeatView(self, componentForColumn: column, at: row)
                components[row].insert(component, at: column)
                switch component {
                case _ as SeatText: break loop
                case let space as Space:
                    if space.isFullSize {
                        break loop
                    } else {
                        break
                    }
                default: break
                }
            }
        }
        self.cinemaComponents = components
    }
    
    func onSeatAreaTapped(on point: CGPoint) {
        let column = Int(floor(point.x / (seatWidth + seatSpacing)))
        let row = Int(floor(point.y / (seatWidth + seatSpacing)))
        print("Row = \(row) - Column = \(column)")
        
        guard cinemaComponents.count > row && cinemaComponents[row].count > column else {
            return
        }
        if var seat = cinemaComponents[row][column] as? Seat {
            switch seat.state {
            case .available:
                delegate?.didSelectSeat(seat)
            case .selected:
                delegate?.didUnSelectSeat(row: row, column: column)
            default: break
            }
            
            seat.changeState()
            cinemaComponents[row][column] = seat
        }
    }

}

protocol CinemaSeatComponent {  // Space & Text
    
    var row: Int { get set }
    
    var column: Int { get set }
    
}

struct Seat: CinemaSeatComponent {
    
    enum State {
        case available
        case unavailable
        case selected
    }
    
    var row: Int
    var column: Int
    var state: State
    var text: String
    var data: Any
    
    mutating func changeState() {
        switch state {
        case .available:
            state = .selected
        case .selected:
            state = .available
        default: break
        }
    }
}

struct Space: CinemaSeatComponent {
    
    var row: Int
    var column: Int
    let isFullSize: Bool
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.isFullSize = false
    }
    
    init(row: Int) {
        self.row = row
        self.column = 0
        self.isFullSize = true
    }
    
}

struct SeatText: CinemaSeatComponent {
    
    var row: Int
    var column: Int = 0
    var text: String
    
    init(row: Int, text: String) {
        self.row = row
        self.text = text
    }
    
}
