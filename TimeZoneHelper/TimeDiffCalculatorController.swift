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
        
        <<< TimeZoneSelectorRow(tagStartTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
            row.value = TimeZone.current
        }
        
        form +++ Section(NSLocalizedString("end date", comment: ""))
        
        <<< DateTimeRow(tagEndDateTime) {
            row in
            row.title = NSLocalizedString("Date & Time", comment: "")
            row.value = now.addingTimeInterval(3600)
        }
    }
}
