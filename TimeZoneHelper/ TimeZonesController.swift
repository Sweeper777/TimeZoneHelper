import UIKit
import RealmSwift

class TimeZonesController: UITableViewController {
    var timeZones: Results<UserTimeZones>!
    
    override func viewDidLoad() {
        timeZones = (try? Realm())?.objects(UserTimeZones.self).sorted(byKeyPath: "position")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeZones.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        return cell
    }
}
