import UIKit

class TimeZoneNamesController: UITableViewController, UISearchResultsUpdating {
    let allTimeZoneNames = { () -> [(String, String)] in 
        var tzs = TimeZone.abbreviationDictionary.map { ($0.key, $0.value) }
        let names = tzs.map { $0.1 }
        var allIdentifiers = TimeZone.knownTimeZoneIdentifiers
        for identifier in allIdentifiers where !names.contains(identifier) {
            tzs.append(("", identifier))
        }
        return tzs.map { ($0.0, $0.1.replacingOccurrences(of: "_", with: " ")) }
    }()
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
        searchController.searchBar.barTintColor = UIColor(hex: "5abb5a")
        searchController.searchBar.tintColor = .white
    }
    
    func filterTimeZoneNames(with searchText: String) {
        filteredTimeZoneNames = allTimeZoneNames.filter {
            $0.0.lowercased().contains(searchText.lowercased()) || $0.1.lowercased().contains(searchText.lowercased())
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
            cell.textLabel?.text = displayTextFor(timeZoneTuple: filteredTimeZoneNames[indexPath.row])
        } else {
            cell.textLabel?.text = displayTextFor(timeZoneTuple: allTimeZoneNames[indexPath.row])
        }
        return cell
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tuple = isSearching ? filteredTimeZoneNames[indexPath.row] : allTimeZoneNames[indexPath.row]
        let timeZone = TimeZone(abbreviation: tuple.0)!
        delegate?.didSelectTimeZone(timeZone: timeZone, customLabelText: displayTextFor(timeZoneTuple: tuple))
        if isSearching {
            dismiss(animated: false, completion: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func displayTextFor(timeZoneTuple: (String, String)) -> String {
        if timeZoneTuple.0 == "" {
            return "\(timeZoneTuple.1)"
        } else {
            return "\(timeZoneTuple.1) (\(timeZoneTuple.0))"
        }
    }
}
