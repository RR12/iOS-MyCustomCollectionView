//
//  ViewController.swift
//  MyCustomCollectionView
//
//  Created by Khairil Ushan on 10/18/17.
//  Copyright © 2017 Khairil Ushan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cinemaSeatLayout: CinemaSeatLayout!

    fileprivate var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        cinemaSeatLayout.delegate = self
        cinemaSeatLayout.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - CinemaSeatLayoutDelegate
extension ViewController: CinemaSeatLayoutDelegate {

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didSelect seat: Seat) {
        print(seat.data)
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didUnSelectSeat row: Int, column: Int) {
        
    }

}

// MARK: - CinemaSeatLayoutDataSource
extension ViewController: CinemaSeatLayoutDataSource {

    func numberOfRow(in cinemaSeatLayout: CinemaSeatLayout) -> Int {
        return 14
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, numberOfColumnAt row: Int) -> Int {
        return 20
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, componentForColumn column: Int, at row: Int) ->
            CinemaSeatComponent {
        return viewModel.getComponent(for: row, column: column)
    }
    
    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, guideTextForRow: Int) -> String {
        return viewModel.getGuideTextFor(guideTextForRow)
    }

}

class ViewModel {
    
    private var guideRow = 64

    func getComponent(for row: Int, column: Int) -> CinemaSeatComponent {
        
        switch row {
        case 3, 6, 11:
            return Space(row: row)
        case 0:
            return SeatText(row: row, text: "beanbag seat")
        case 4:
            return SeatText(row: row, text: "lounger seat")
        case 7:
            return SeatText(row: row, text: "cinema seat")
        case 12:
            return SeatText(row: row, text: "sofa seat")
        default:
            switch row {
            case 1, 2:
                switch column {
                case 0, 1, 18, 19:
                    return Space(row: row, column: column)
                default:
                    let char = Character(UnicodeScalar(65 + row)!)
                    return Seat(row: row, column: column, state: (row + column) % 5 == 0 ? .unavailable : .available, text: "1", data: "\(String(char)) - \(column)")
                }
            case 13:
                if column % 3 == 2 {
                    return Space(row: row, column: column)
                } else {
                    let char = Character(UnicodeScalar(65 + row)!)
                    return Seat(row: row, column: column, state: .unavailable, text: "1", data: "\(String(char)) - \(column)")
                }
            default:
                let char = Character(UnicodeScalar(65 + row)!)
                return Seat(row: row, column: column, state: (row + column) % 5 == 0 ? .unavailable : .available, text: "1", data: "\(String(char)) - \(column)")
            }
        }
    }
    
    func getGuideTextFor(_ row: Int) -> String {
        switch row {
        case 0, 3, 4, 6, 7, 11, 12:
            return ""
        default:
            guideRow += 1
            return String(Character(UnicodeScalar(guideRow)!))
        }
    }

}
