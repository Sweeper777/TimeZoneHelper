import Eureka

class TimeZoneSelectorController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Select a Time Zone", comment: "")
        form +++ Section(NSLocalizedString("select from...", comment: "")) {
            section in
            section.tag = tagMethodSelectionSection
        }
        
        <<< ButtonRow(tagMap) {
            row in
            row.title = NSLocalizedString("Map", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
        
        <<< ButtonRow(tagLocation) {
            row in
            row.title = NSLocalizedString("Location", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
            
        <<< ButtonRow(tagOffsetFromGMT) {
            row in
            row.title = NSLocalizedString("Offset from GMT", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
        
        <<< ButtonRow(tagAbbreviation) {
            row in
            row.title = NSLocalizedString("Abbreviation", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
        
        form +++ Section() {
            section in
            section.tag = tagSelectedTimeZoneSection
        }
        
        <<< LabelRow(tagSelectedTimeZone) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Selected Time Zone", comment: "")
        }
    }
}
