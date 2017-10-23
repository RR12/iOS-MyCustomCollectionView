//
//  CinemaSeatLayout.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/18/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

protocol CinemaSeatLayoutDelegate: class {

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didSelectSeat row: Int, column: Int)

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didUnSelectSeat row: Int, column: Int)

}

protocol CinemaSeatLayoutDataSource: class {

    func numberOfRow(in cinemaSeatLayout: CinemaSeatLayout) -> Int

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, numberOfColumnAt row: Int) -> Int

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, componentForColumn column: Int, at row: Int) ->
            CinemaSeatComponent

}

class CinemaSeatLayout: UIView {

    @IBOutlet weak var seatScrollView: UIScrollView!
    @IBOutlet weak var seatView: CinemaSeatView!
    @IBOutlet weak var leftGuideView: CinemaGuideView!
    @IBOutlet weak var rightGuideView: CinemaGuideView!

    weak var delegate: CinemaSeatLayoutDelegate?
    weak var dataSource: CinemaSeatLayoutDataSource?

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        if subviews.count == 0,
            let view = Bundle.main.loadNibNamed("CinemaSeatLayout", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
        seatView.currentScale = 1.0
        seatView.isUserInteractionEnabled = true
        seatView.delegate = self

        seatScrollView.minimumZoomScale = 1.0
        seatScrollView.maximumZoomScale = 4.0
        seatScrollView.delegate = self
        seatScrollView.canCancelContentTouches = true
        seatScrollView.delaysContentTouches = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onSeatAreaTapped(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        seatView.addGestureRecognizer(tapGesture)
    }

    @objc func onSeatAreaTapped(gesture: UITapGestureRecognizer) {
        let tappedPoint = gesture.location(in: seatView)
        print("Tapped point = \(tappedPoint)")
        seatView.onSeatAreaTapped(on: tappedPoint)
    }

    private func invalidateGuideViews() {
        leftGuideView.setNeedsDisplay()
        rightGuideView.setNeedsDisplay()
    }

    private func updateGuideContentOffsetAndSize() {
        let guideContentSize = CGSize(width: leftGuideView.frame.width, height: seatScrollView.contentSize.height)
        leftGuideView.contentSize = guideContentSize
        rightGuideView.contentSize = guideContentSize

        let guideContentOffset = CGPoint(x: 0, y: seatScrollView.contentOffset.y)
        leftGuideView.contentOffset = guideContentOffset
        rightGuideView.contentOffset = guideContentOffset

        invalidateGuideViews()
    }

    func setSeats(_ seats: [Seat]) {
        var row = 64
        var currentRow = -1
        var rows = [String]()
        seats.forEach { seat in
            if currentRow != seat.row {
                currentRow = seat.row
                row += 1
                let char = Character(UnicodeScalar(row)!)
                rows.append(String(char))
            }
        }
        leftGuideView.rows = rows
        rightGuideView.rows = rows
        seatView.seats = seats
    }

}

extension CinemaSeatLayout: UIScrollViewDelegate {

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return seatView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("\nScale = \(scrollView.zoomScale)\nScrollView Content Size = \(scrollView.contentSize)")
        seatView.currentScale = scrollView.zoomScale
        updateGuideContentOffsetAndSize()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("\nScale = \(scrollView.zoomScale)\nScrollView Content Offset = \(scrollView.contentOffset)")
        updateGuideContentOffsetAndSize()
    }

}

extension CinemaSeatLayout: CinemaSeatViewDelegate {

    func onSeatSizeChanged(_ size: CGSize) {
        leftGuideView.updateRowHeight(size.height)
        rightGuideView.updateRowHeight(size.height)
    }

    func didSelectSeat(row: Int, column: Int) {
        delegate?.cinemaSeatLayout(self, didSelectSeat: row, column: column)
    }

    func didUnSelectSeat(row: Int, column: Int) {
        delegate?.cinemaSeatLayout(self, didUnSelectSeat: row, column: column)
    }

}

protocol CinemaSeatComponent {

}
