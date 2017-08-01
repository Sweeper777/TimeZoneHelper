import Eureka
import SCLAlertView

class TimeZoneSelectorController: FormViewController {
    var selectedTimeZone: TimeZone?
    
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
        }.onCellSelection {
            cell, row in
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            let textField = alert.addTextField()
            textField.placeholder = "-5, +7 etc."
            alert.addButton(NSLocalizedString("OK", comment: "")) {
                if let offset = Double(textField.text ?? ""), let timeZone = TimeZone(secondsFromGMT: Int(offset * 60 * 60)) {
                    self.selectedTimeZone = timeZone
                    self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.hidden = false
                    self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.evaluateHidden()
                    self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = true
                    self.form.sectionBy(tag: tagMethodSelectionSection)?.evaluateHidden()
                    (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).value = timeZone.identifier
                } else {
                    let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false, showCircularIcon: false))
                    alert.addButton(NSLocalizedString("OK", comment: ""), action: {})
                    _ = alert.showCustom(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("The offset entered is invalid.", comment: ""), color: .red, icon: UIImage())
                }
            }
            alert.addButton(NSLocalizedString("Cancel", comment: ""), action: {})
            _ = alert.showCustom(NSLocalizedString("GMT offset", comment: ""), subTitle: NSLocalizedString("Please enter the offset from GMT, in hours", comment: ""), color: UIColor(hex: "3b7b3b"), icon: #imageLiteral(resourceName: "globe"))
        }
        
        <<< ButtonRow(tagAbbreviation) {
            row in
            row.title = NSLocalizedString("Abbreviation", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
        
        form +++ Section() {
            section in
            section.tag = tagSelectedTimeZoneSection
            section.hidden = false
        }
        
        <<< LabelRow(tagSelectedTimeZone) {
            row in
            row.cellStyle = .value1
            row.title = NSLocalizedString("Selected Time Zone", comment: "")
        }
        
        <<< ButtonRow(tagReselect) {
            row in
            row.title = NSLocalizedString("Reselect", comment: "")
            row.cell.tintColor = .red
        }.onCellSelection {
            cell, row in
            row.section?.hidden = false
            self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = false
        }
        
        <<< ButtonRow(tagOK) {
            row in
            row.title = NSLocalizedString("OK", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }
    }
}
