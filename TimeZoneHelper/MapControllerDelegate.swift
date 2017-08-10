import Foundation

protocol MapControllerDelegate : class {
    func didSelectTimeZone(timeZone: TimeZone, customLabelText: String)
}
