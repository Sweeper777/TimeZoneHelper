import RealmSwift

class UserTimeZones: Object {
    dynamic var timeZoneInfo = Data()
    
    var timeZone: TimeZone {
        return NSKeyedUnarchiver.unarchiveObject(with: timeZoneInfo) as! TimeZone
    }
}
