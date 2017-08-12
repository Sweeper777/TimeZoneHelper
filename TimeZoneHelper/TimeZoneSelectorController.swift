import Eureka
import SCLAlertView
import CoreLocation
import EZLoadingActivity
import LatLongToTimezone

class TimeZoneSelectorController: FormViewController, TimeZoneNamesControllerDelegate, MapControllerDelegate, TypedRowControllerType {
    var selectedTimeZone: TimeZone? {
        willSet {
            row?.value = newValue
        }
    }
    var customLabelText: String?
    
    weak var delegate: TimeZoneSelectorControllerDelegate?

    public var onDismissCallback: ((UIViewController) -> ())?
    var row: RowOf<TimeZone>!
    var completionCallback: ((UIViewController) -> ())?
    
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
            }.onCellSelection {
                cell, row in
                self.performSegue(withIdentifier: "showMap", sender: nil)
            }
        
        <<< ButtonRow(tagLocation) {
            row in
            row.title = NSLocalizedString("Location", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
            }.onCellSelection {
                cell, row in
                let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                let textField = alert.addTextField()
                textField.placeholder = NSLocalizedString("Name of city or area", comment: "")
                alert.addButton(NSLocalizedString("OK", comment: "")) {
                    let geocoder = CLGeocoder()
                    EZLoadingActivity.show(NSLocalizedString("Looking for the requested location...", comment: ""), disableUI: true)
                    geocoder.geocodeAddressString(textField.text!, completionHandler: { (placemarks, error) in
                        EZLoadingActivity.hide()
                        if error != nil || placemarks?.first == nil {
                            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false, showCircularIcon: false))
                            alert.addButton(NSLocalizedString("OK", comment: ""), action: {})
                            _ = alert.showCustom(NSLocalizedString("Error", comment: ""), subTitle: NSLocalizedString("Unable to find the requested location", comment: ""), color: .red, icon: UIImage())
                        } else {
                            self.selectedTimeZone = TimezoneMapper.latLngToTimezone(placemarks!.first!.location!.coordinate)
                            self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.hidden = false
                            self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.evaluateHidden()
                            self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = true
                            self.form.sectionBy(tag: tagMethodSelectionSection)?.evaluateHidden()
                            (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).cell.textLabel?.text = textField.text!
                            (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).cell.detailTextLabel?.text = self.selectedTimeZone!.identifier
//                            (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).updateCell()
                            self.customLabelText = textField.text
                        }
                    })
                }
                alert.addButton(NSLocalizedString("Cancel", comment: ""), action: {})
                _ = alert.showCustom(NSLocalizedString("Location", comment: ""), subTitle: NSLocalizedString("Please enter a location", comment: ""), color: UIColor(hex: "3b7b3b"), icon: #imageLiteral(resourceName: "globe"))
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
                    (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).title = timeZone.identifier
                    (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).updateCell()
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
            row.title = NSLocalizedString("Abbreviation/Name", comment: "")
            row.cell.tintColor = UIColor(hex: "3b7b3b")
        }.onCellSelection {
            cell, row in
            self.performSegue(withIdentifier: "showTimeZoneNames", sender: nil)
        }
        
        form +++ Section(NSLocalizedString("selected time zone", comment: "")) {
            section in
            section.tag = tagSelectedTimeZoneSection
            section.hidden = true
        }
        
        <<< LabelRow(tagSelectedTimeZone) {
            row in
            row.cellStyle = .subtitle
        }
        
        <<< ButtonRow(tagReselect) {
            row in
            row.title = NSLocalizedString("Reselect", comment: "")
            row.cell.tintColor = .red
        }.onCellSelection {
            cell, row in
            row.section?.hidden = true
            row.section?.evaluateHidden()
            self.selectedTimeZone = nil
            self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = false
            self.form.sectionBy(tag: tagMethodSelectionSection)?.evaluateHidden()
        }
        
        if row == nil {
            form.allSections.last! <<< ButtonRow(tagOK) {
                row in
                row.title = NSLocalizedString("OK", comment: "")
                row.cell.tintColor = UIColor(hex: "3b7b3b")
            }.onCellSelection {
                cell, row in
                self.delegate?.didSelectTimeZone(timeZone: self.selectedTimeZone!, labelText: self.customLabelText)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        if let rowValue = row?.value {
            self.selectedTimeZone = rowValue
            self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.hidden = false
            self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.evaluateHidden()
            self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = true
            self.form.sectionBy(tag: tagMethodSelectionSection)?.evaluateHidden()
            (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).title = rowValue.identifier
            (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).updateCell()
        }
    }

    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didSelectTimeZone(timeZone: TimeZone, customLabelText: String) {
        self.selectedTimeZone = timeZone
        self.customLabelText = customLabelText
        self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.hidden = false
        self.form.sectionBy(tag: tagSelectedTimeZoneSection)?.evaluateHidden()
        self.form.sectionBy(tag: tagMethodSelectionSection)?.hidden = true
        self.form.sectionBy(tag: tagMethodSelectionSection)?.evaluateHidden()
        (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).title = customLabelText
        (self.form.rowBy(tag: tagSelectedTimeZone) as! LabelRow).updateCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = (segue.destination as? UINavigationController)?.topViewController as? TimeZoneNamesController {
            vc.delegate = self
        } else if let vc = (segue.destination as? UINavigationController)?.topViewController as? MapController {
            vc.delegate = self
        }
    }
}
