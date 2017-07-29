import RealmSwift

class UserTimeZones: Object {
    dynamic var timeZoneInfo = Data()
    dynamic var position = 0
    dynamic var labelText = ""
    
    var timeZone: TimeZone {
        return NSKeyedUnarchiver.unarchiveObject(with: timeZoneInfo) as! TimeZone
    }
}
