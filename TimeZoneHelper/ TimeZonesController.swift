import UIKit
import RealmSwift

class TimeZonesController: UITableViewController, TimeZoneSelectorControllerDelegate {
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
        let timeZone = timeZones[indexPath.row]
        (cell.contentView.viewWithTag(1) as! UILabel).text = timeZone.labelText
        (cell.contentView.viewWithTag(2) as! UILabel).text = dayStringFromTimeZone(timeZone.timeZone)
        let formatter = DateFormatter()
        formatter.timeZone = timeZone.timeZone
        formatter.dateFormat = "HH:mm"
        (cell.contentView.viewWithTag(3) as! UILabel).text = formatter.string(from: Date())
        return cell
    }
    
    @IBAction func newTimeZone() {
        performSegue(withIdentifier: "newTimeZone", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = (segue.destination as? UINavigationController)?.topViewController as? TimeZoneSelectorController {
            vc.delegate = self
        }
    }
    
    func didSelectTimeZone(timeZone: TimeZone) {
        
    }
}
