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
        <<< TimeZoneSelectorRow(tagEndTimeZone) {
            row in
            row.title = NSLocalizedString("Time Zone", comment: "")
            row.value = TimeZone.current
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
    }
    
    func combine(_ date: Date, with timeZone: TimeZone) -> Date? {
        var cal = Calendar.current
        let comp = cal.dateComponents([.era, .year, .month, .day, .hour, .minute, .second], from: date)
        cal.timeZone = timeZone
        return cal.date(from: comp)
    }
}
