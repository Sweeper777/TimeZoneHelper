import Eureka

class TimeZoneInfoController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        form +++ TimeZoneSelectorRow(tag: tagTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
        }
        
        form +++ Section() {
            section in
            section.tag = tagInfoSection
            section.hidden = Condition.function([tagTimeZone]) {
                $0.rowBy(tag: tagTimeZone)?.baseValue == nil
            }
        }
        
        <<< LabelRow(tagName) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Name", comment: "")
        }
        
    }
}
