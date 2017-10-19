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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

