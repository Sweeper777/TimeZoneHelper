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
        
        form +++ TimeZoneSelectorRow(tagTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
        }.onChange {
            [weak self]
            row in
            self?.updateInfoRows()
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
        addInfoRow(tag: tagCurrentTime, title: "Current Time")
        
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
        
        form +++ ButtonRow(tagRefreshInfo) {
            row in
            row.title = NSLocalizedString("Refresh Info", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }.onChange {
            [weak self]
            row in
            self?.updateInfoRows()
        }
    }
    
    func updateInfoRows() {
        let row: RowOf<TimeZone>? = form.rowBy(tag: tagTimeZone)
        guard let timeZone = row?.value else { return }
        func setInfoRow(withTag tag: String, value: String) {
            let infoRow: RowOf<String> = form.rowBy(tag: tag)!
            infoRow.value = value
            infoRow.updateCell()
        }
        setInfoRow(withTag: tagName, value: timeZone.identifier)
        setInfoRow(withTag: tagAbbreviation, value: timeZone.abbreviation() ?? NSLocalizedString("N/A", comment: ""))
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        let gmtOffset = Double(timeZone.secondsFromGMT()) / 60.0 / 60.0
        setInfoRow(withTag: tagOffsetFromGMT, value: "\(numberFormatter.string(from: gmtOffset as NSNumber)!) \(NSLocalizedString("Hour(s)", comment: ""))")
        
        setInfoRow(withTag: tagIsDST, value: NSLocalizedString(timeZone.isDaylightSavingTime() ? "Yes" : "No", comment: ""))
        let dstOffset = timeZone.daylightSavingTimeOffset() / 60.0 / 60.0
        setInfoRow(withTag: tagDSTOffset, value: "\(numberFormatter.string(from: dstOffset as NSNumber)!) \(NSLocalizedString("Hour(s)", comment: ""))")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        if let transitionDate = timeZone.nextDaylightSavingTimeTransition {
            setInfoRow(withTag: tagNextDSTTransition, value: dateFormatter.string(from: transitionDate))
        } else {
            setInfoRow(withTag: tagNextDSTTransition, value: NSLocalizedString("N/A", comment: ""))
        }
        dateFormatter.dateFormat = "HH:ss"
        dateFormatter.timeZone = timeZone
        setInfoRow(withTag: tagCurrentTime, value: dateFormatter.string(from: Date()))
    }
}
