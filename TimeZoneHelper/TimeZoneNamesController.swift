import UIKit

class TimeZoneNamesController: UITableViewController {
    let allTimeZoneNames = TimeZone.abbreviationDictionary.map { ($0.key, $0.value.replacingOccurrences(of: "_", with: " ")) }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTimeZoneNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(allTimeZoneNames[indexPath.row].0) (\(allTimeZoneNames[indexPath.row].1))"
        return cell
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
}
