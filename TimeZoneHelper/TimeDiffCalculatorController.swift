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
        }.onChange {
            [weak self]
            row in
            self?.updateLabelRows()
        }
        
        <<< TimeZoneSelectorRow(tagStartTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
            row.value = TimeZone.current
        }.onChange {
            [weak self]
            row in
            if row.value != nil {
                self?.updateLabelRows()
            }
        }
        
        form +++ Section(NSLocalizedString("end date", comment: ""))
        
        <<< DateTimeRow(tagEndDateTime) {
            row in
            row.title = NSLocalizedString("Date & Time", comment: "")
            row.value = now.addingTimeInterval(3600)
        }.onChange {
            [weak self]
            row in
            self?.updateLabelRows()
        }
        <<< TimeZoneSelectorRow(tagEndTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
            row.value = TimeZone.current
        }.onChange {
            [weak self]
            row in
            if row.value != nil {
                self?.updateLabelRows()
            }
        }
        
        form +++ Section(NSLocalizedString("time difference", comment: ""))
        
        <<< LabelRow(tagDaysDiff) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Day(s)", comment: "")
        }
        
        <<< LabelRow(tagHoursDiff) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Hour(s)", comment: "")
        }
        
        <<< LabelRow(tagMinutesDiff) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Minute(s)", comment: "")
        }
        updateLabelRows()
    }
    
    func combine(_ date: Date, with timeZone: TimeZone) -> Date? {
        var cal = Calendar.current
        let comp = cal.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: date)
        cal.timeZone = timeZone
        return cal.date(from: comp)
    }
    
    func difference(between startDate: Date, in startTimeZone: TimeZone, and endDate: Date, in endTimeZone: TimeZone) -> TimeInterval! {
        guard let zonedStartDate = combine(startDate, with: startTimeZone), let zonedEndDate = combine(endDate, with: endTimeZone) else { return nil }
        return abs(zonedEndDate.timeIntervalSince(zonedStartDate))
    }
    
    func updateLabelRows() {
        let values = form.values()
        guard let timeDiff = difference(
            between: values[tagStartDateTime] as! Date,
            in: values[tagStartTimeZone] as! TimeZone,
            and: values[tagEndDateTime] as! Date,
            in: values[tagEndTimeZone] as! TimeZone) else {
                (form.rowBy(tag: tagMinutesDiff) as! LabelRow).value = NSLocalizedString("Invalid Date!", comment: "")
                (form.rowBy(tag: tagHoursDiff) as! LabelRow).value = NSLocalizedString("Invalid Date!", comment: "")
                (form.rowBy(tag: tagDaysDiff) as! LabelRow).value = NSLocalizedString("Invalid Date!", comment: "")
                form.allSections.last?.forEach { $0.updateCell() }
                return
        }
        let minutes = round(timeDiff / 60)
        let hours = floor(minutes / 60)
        let displayMinutes = Int(minutes) % 60
        let days = Int(floor(hours / 24))
        let displayHours = Int(hours) % 24
        (form.rowBy(tag: tagMinutesDiff) as! LabelRow).value = "\(displayMinutes)"
        (form.rowBy(tag: tagHoursDiff) as! LabelRow).value = "\(displayHours)"
        (form.rowBy(tag: tagDaysDiff) as! LabelRow).value = "\(days)"
        form.allSections.last?.forEach { $0.updateCell() }
    }
}
