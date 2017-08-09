import UIKit

class TimeZoneNamesController: UITableViewController, UISearchResultsUpdating {
    let allTimeZoneNames = TimeZone.abbreviationDictionary.map { ($0.key, $0.value.replacingOccurrences(of: "_", with: " ")) }
    var filteredTimeZoneNames = [(String, String)]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearching: Bool {
        return searchController.searchBar.text != ""
    }
    
    weak var delegate: TimeZoneNamesControllerDelegate?
    
    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    func filterTimeZoneNames(with searchText: String) {
        filteredTimeZoneNames = allTimeZoneNames.filter {
            $0.0.contains(searchText) || $0.1.contains(searchText)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterTimeZoneNames(with: searchController.searchBar.text!)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredTimeZoneNames.count
        }
        return allTimeZoneNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if isSearching {
            cell.textLabel?.text = "\(filteredTimeZoneNames[indexPath.row].0) (\(filteredTimeZoneNames[indexPath.row].1))"
        } else {
            cell.textLabel?.text = "\(allTimeZoneNames[indexPath.row].0) (\(allTimeZoneNames[indexPath.row].1))"
        }
        return cell
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuple = isSearching ? filteredTimeZoneNames[indexPath.row] : allTimeZoneNames[indexPath.row]
        let timeZone = TimeZone(abbreviation: tuple.0)!
        delegate?.didSelectTimeZone(timeZone: timeZone, customLabelText: "\(tuple.0) (\(tuple.1))")
        dismiss(animated: true, completion: nil)
    }
}
