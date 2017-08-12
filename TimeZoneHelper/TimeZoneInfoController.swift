import Eureka

class TimeZoneInfoController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ TimeZoneSelectorRow(tag: tagTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
        }
    }
}
