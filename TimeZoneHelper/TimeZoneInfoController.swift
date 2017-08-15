import Eureka

class TimeZoneInfoController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func addInfoRow(tag: String, title: String) {
            form.allSections.last! <<< LabelRow(tag) {
                row in
                row.cellStyle = .value1
                row.title = NSLocalizedString(title, comment: "")
            }
        }
        
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
        
        addInfoRow(tag: tagName, title: "Name")
        addInfoRow(tag: tagAbbreviation, title: "Abbreviation")
        addInfoRow(tag: tagOffsetFromGMT, title: "Offset from GMT")
        
        form +++ Section(NSLocalizedString("daylight saving time (dst) info", comment: "")) {
            section in
            section.tag = tagDSTInfoSection
            section.hidden = Condition.function([tagTimeZone]) {
                $0.rowBy(tag: tagTimeZone)?.baseValue == nil
            }
        }
        
        addInfoRow(tag: tagIsDST, title: "Is Currently Daylight Saving")
        addInfoRow(tag: tagDSTOffset, title: "Current DST Offset")
        addInfoRow(tag: tagNextDSTTransition, title: "Next DST Transition")
    }
}
