import UIKit

protocol TimeZoneSelectorControllerDelegate: class {
    func didSelectTimeZone(timeZone: TimeZone, labelText: String?)
}
