# iOS-MyCustomCollectionView

# CinemaSeatLayout

### How To
Here is how you can use it on your ViewController.

```
class ViewController: UIViewController {

    @IBOutlet weak var cinemaSeatLayout: CinemaSeatLayout!

    fileprivate var viewModel = YourViewModel()

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
        viewModel.onSeatSelected(seat)
    }

    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, didUnSelectSeat row: Int, column: Int) {
        viewModel.onSeatUnSelected(seat)
    }

}

// MARK: - CinemaSeatLayoutDataSource
extension ViewController: CinemaSeatLayoutDataSource {

    // Get total row in the cinema
    func numberOfRow(in cinemaSeatLayout: CinemaSeatLayout) -> Int {
        return viewModel.getCinemaRowCount()
    }

    // Get total column on each row
    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, numberOfColumnAt row: Int) -> Int {
        return viewModel.getCinemaColumnCount(at: row)
    }

    // Get component for each row and column. There're 3 types of CinemaComponent
    // - Seat : Normal seat with 3 kind of state (.available, .unavailable, .selected)
    // - Space : To add gap between seat
    // - SeatText : To add text in a row and the text will be full width
    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, componentForColumn column: Int, at row: Int) ->
            CinemaSeatComponent {
        return viewModel.getComponent(for: row, column: column)
    }
    
    func cinemaSeatLayout(_ cinemaSeatLayout: CinemaSeatLayout, guideTextFor row: Int) -> String {
        return viewModel.getGuideTextFor(row)
    }

}
```

### Contributor
- @IvanMTM
