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

    private var viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Dummy seats
        var seats = [Seat]()
        for row in 0...20 {
            for column in 0...20 {
                let randomState: Seat.State = (row + column) % 5 == 0 ? .unavailable : .available
                seats.append(Seat(row: row, column: column, state: randomState))
            }
        }
        cinemaSeatLayout.setSeats(seats)
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

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didSelectSeat row: Int, column: Int) {

    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didUnSelectSeat row: Int, column: Int) {

    }

}

extension ViewController: CinemaSeatLayoutDataSource {

    func numberOfRow(in cinemaSeatLayout: CinemaSeatLayout) -> Int {
        return 20
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, numberOfColumnAt row: Int) -> Int {
        return 20
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, componentForColumn column: Int, at row: Int) ->
            CinemaSeatComponent {
        return viewModel.getComponent(for: row, column: column)
    }

}

class ViewModel {

    func getComponent(for row: Int, column: Int) -> CinemaSeatComponent {
        fatalError()
    }

}
