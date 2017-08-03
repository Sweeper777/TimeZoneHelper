import UIKit
import RealmSwift

class TimeZonesController: UITableViewController, TimeZoneSelectorControllerDelegate {
    var timeZones: Results<UserTimeZones>!
    var realm: Realm!
    
    override func viewDidLoad() {
        realm = try! Realm()
        timeZones = realm.objects(UserTimeZones.self).sorted(byKeyPath: "position")
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! realm.write {
                realm.delete(timeZones[indexPath.row])
                for i in indexPath.row..<timeZones.count {
                    timeZones[i].position = i
                }
                tableView.deleteRows(at: [indexPath], with: .left)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            timeZones[sourceIndexPath.row].position = destinationIndexPath.row
            timeZones[destinationIndexPath.row].position = sourceIndexPath.row
        }
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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
        let userTimeZone = UserTimeZones()
        userTimeZone.timeZoneInfo = NSKeyedArchiver.archivedData(withRootObject: timeZone)
        userTimeZone.labelText = timeZone.identifier
        userTimeZone.position = timeZones.count
        try! realm.write {
            realm.add(userTimeZone)
        }
        tableView.reloadData()
    }
    
    func updateClockDisplays() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        for i in 0..<timeZones.count {
            formatter.timeZone = timeZones[i].timeZone
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0))!
            (cell.viewWithTag(3) as! UILabel).text = formatter.string(from: Date())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = {
            self.updateClockDisplays()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).clock.onTimerChange = nil
    }
}
