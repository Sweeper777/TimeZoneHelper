import Foundation

protocol TimeZoneNamesControllerDelegate : class {
    func didSelectTimeZone(timeZone: TimeZone, customLabelText: String)
}
