import Eureka

class TimeDiffCalculatorController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Date()
        
        form +++ Section(NSLocalizedString("start date", comment: ""))
        
        <<< DateTimeRow(tagStartDateTime) {
            row in
            row.title = NSLocalizedString("Date & Time", comment: "")
            row.value = now
        }
    }
}
