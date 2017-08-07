import UIKit

class TimeZoneNamesController: UITableViewController {
    let allTimeZoneNames = TimeZone.abbreviationDictionary.map { ($0.key, $0.value.replacingOccurrences(of: "_", with: " ")) }
}
