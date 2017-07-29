import RealmSwift

class UserTimeZones: Object {
    dynamic var timeZoneInfo = Data()
    dynamic var position = 0
    
    var timeZone: TimeZone {
        return NSKeyedUnarchiver.unarchiveObject(with: timeZoneInfo) as! TimeZone
    }
}
