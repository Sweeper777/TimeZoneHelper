import UIKit
import RealmSwift

class TimeZonesController: UITableViewController {
    var timeZones: Results<UserTimeZones>!
    
    override func viewDidLoad() {
        timeZones = (try? Realm())?.objects(UserTimeZones.self)
    }
}
